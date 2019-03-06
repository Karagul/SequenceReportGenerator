# Gets data ready for creaing the sequence reports
# For demultiplex data

PREFIX=$1
NUM_TOTAL_READS_FILE=$2
NUM_PHIX_READS_FILE=$3
BARCODES_FILE=$4

if [ -z $PREFIX ] || [ -z $NUM_TOTAL_READS_FILE ] || [ -z $NUM_PHIX_READS_FILE ]; then
	echo "Incomplete arguments."
	echo "./buildReadReport.sh <Prefix> <NumTotalReads path> <NumPhixReads path> <demultiplex Barcodes path (optional)>"
	exit 1
fi

sed -e 's/ /,/g' $NUM_TOTAL_READS_FILE > ${PREFIX}_NumTotalReads.csv
sed -i -e 's/\.R1//' ${PREFIX}_NumTotalReads.csv
sed -e 's/ /,/g' $NUM_PHIX_READS_FILE > ${PREFIX}_NumPhixReads.csv
paste ${PREFIX}_NumTotalReads.csv ${PREFIX}_NumPhixReads.csv -d ',' > ${PREFIX}_ReadReport.csv.temp 
awk -F',' '{print $1","$2","$4}' ${PREFIX}_ReadReport.csv.temp > ${PREFIX}_ReadReport.csv.temp2

if [ -z $BARCODES_FILE ]; then
	echo "Library,NumReads,NumReadsPhix,NumReadsGood" > header.temp
	awk -F',' '{ $4 = $2 - $3 } 1' ${PREFIX}_ReadReport.csv.temp2 > ${PREFIX}_ReadReport.csv.temp3
	sed -i -e 's/ /,/g' ${PREFIX}_ReadReport.csv.temp3
	awk -F',' '{print $1","$2","$3","$4}' ${PREFIX}_ReadReport.csv.temp3 > ${PREFIX}_ReadReport.csv.temp7
else
	NUM_LIBRARIES=`wc -l ${PREFIX}_NumTotalReads.csv`
	PERCENT_EXPECTED=$( echo $NUM_LIBRARIES | python -c "import sys; i =  ([1 / float (line.split (' ')[0] ) for line in sys.stdin] ); print (i[0])")
	sed -i -e "s/\$/,$PERCENT_EXPECTED/" ${PREFIX}_ReadReport.csv.temp2
	awk -F',' '{print $2}' ${PREFIX}_NumTotalReads.csv | python -c "import sys; reads = ([float (line) for line in sys.stdin]); total = sum(reads); print '\n'.join([str (line / total) for line in reads])" > ${PREFIX}_ObservedProportions.temp
	echo "Barcode,Library,NumReads,NumReadsPhix,NumReadsGood,PercentObtained,PercentExpected,Difference" > header.temp
	awk '{print $1}' $BARCODES_FILE > ${PREFIX}_Barcodes.txt
	paste ${PREFIX}_Barcodes.txt ${PREFIX}_ReadReport.csv.temp2 ${PREFIX}_ObservedProportions.temp -d ',' > ${PREFIX}_ReadReport.csv.temp3
	awk -F',' '{ $7 = $6 - $5 } 1' ${PREFIX}_ReadReport.csv.temp3 > ${PREFIX}_ReadReport.csv.temp4
	sed -i -e 's/ /,/g' ${PREFIX}_ReadReport.csv.temp4
	awk -F',' ' { t = $5; $5 = $6; $6 = t; print; } ' ${PREFIX}_ReadReport.csv.temp4 > ${PREFIX}_ReadReport.csv.temp5
	sed -i -e 's/ /,/g' ${PREFIX}_ReadReport.csv.temp5
	awk -F',' '{ $8 = $3 - $4 } 1' ${PREFIX}_ReadReport.csv.temp5 > ${PREFIX}_ReadReport.csv.temp6
	sed -i -e 's/ /,/g' ${PREFIX}_ReadReport.csv.temp6
	awk -F',' '{print $1","$2","$3","$4","$8","$5","$6","$7}' ${PREFIX}_ReadReport.csv.temp6 > ${PREFIX}_ReadReport.csv.temp7
fi

cat header.temp ${PREFIX}_ReadReport.csv.temp7 > ${PREFIX}_ReadReport.csv

rm ${PREFIX}_ReadReport.csv.temp*
