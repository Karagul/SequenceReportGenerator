

# Path to process radtags file
LOG_FILE=$1

AMBIGUOUS_BARCODES=$(grep '^Ambiguous Barcodes' $LOG_FILE)
read -r -a array <<< "$AMBIGUOUS_BARCODES"
AMBIGUOUS_BARCODES=${array[2]}
AMBIGUOUS_RADTAG=$(grep '^Ambiguous RAD-Tag' $LOG_FILE)
read -r -a array <<< "$AMBIGUOUS_RADTAG"
AMBIGUOUS_RADTAG=${array[2]}
LOW_QUALITY=$(grep '^Low Quality' $LOG_FILE)
read -r -a array <<< "$LOW_QUALITY"
LOW_QUALITY=${array[2]}
TOTAL_SEQUENCES=$(grep '^Total Sequences' $LOG_FILE)
read -r -a array <<< "$TOTAL_SEQUENCES"
TOTAL_SEQUENCES=${array[2]}
RETAINED_READS=$(grep '^Retained Reads' $LOG_FILE)
read -r -a array <<< "$RETAINED_READS"
RETAINED_READS=${array[2]}
TOTAL_REMOVED=$((TOTAL_SEQUENCES-RETAINED_READS))

echo "Ambiguous_Barcodes,Low_Quality,Ambiguous_Radtag,Total_Removed"
echo "$AMBIGUOUS_BARCODES,$LOW_QUALITY,$AMBIGUOUS_RADTAG,$TOTAL_REMOVED"




