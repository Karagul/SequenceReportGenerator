# Sequence Report Generator
## Genomics Core Lab

Generates a report of the results of a sequencing run. 

RMarkdown is used to create a Markdown-formatted report that can be converted to
a number of document formats such as PDF and HTML. The script also outputs CSV files. 

Quanitites of Phix can be supplied to compare the reads obtained to the [Phix](https://en.wikipedia.org/wiki/Phi_X_174) reads. 

### Installation

**Download**

	git clone git@gitlab.com:evankrell/SequenceReportGenerator.git

**Required R packages**

	knitr, rmarkdown, pandoc, optparse, stringr

### How to run:

        Rscript SequenceReportWrapper.R -i <absolute path to ReadReport CSV> \
        -r <absolute path to RemovedReport CSV> \
        -p <project name> -d <date sequenced> -f <header> \
        -o <output directory>

**Example:**

        Rscript SequenceReportWrapper.R -i /home/krell/Documents/SequenceReports/newfmt2/2017-05-09_Sekong_PfalciferPool3_ReadReport.csv \
        -r /home/krell/Documents/SequenceReports/newfmt2/2017-05-09_Sekong_PfalciferPool3_RemovedReport.csv \
        -p SekongPfalciferPool3 -d 2017-05-09 -f @K00291:43:HJFFCBBXX:7:1101:2260:1261:1:N:0:NATCAG \
        -o /home/krell/Documents/SequenceReports/newfmt2/


### Input Files:

Input files are always CSVs. Three types of columns are involved. 

1. Mandatory: column must exist.
2. Optional: column is used for plot/etc, if available.
3. Ignored: column is displayed, but not processed in any way. Any arbitrary column can be included in report. 

**ReadReport CSV**:

_Suggested name format_: [year][month][day]-[ProjectName with Plate and Pool]_ReadReport.csv

    Library,NumReads,NumReadsPhix,NumReadsGood,PercentObtained,PercentExpected,Difference
    1_Muol_RestArea_Plate1Pool2,294689,111,294578,0.0248315319478,0.0208333333333,0.0039982
    2_Muol_RestArea_Plate1Pool2,244004,232,243772,0.0205606355222,0.0208333333333,-0.000272698
    4_Muol_RestArea_Plate1Pool2,320874,87,320787,0.0270379721748,0.0208333333333,0.00620464
    5_Muol_RestArea_Plate1Pool2,87532,249,87283,0.00737575428488,0.0208333333333,-0.0134576
    6_Muol_RestArea_Plate1Pool2,183320,82,183238,0.015447188177,0.0208333333333,-0.00538615
    9_Muol_RestArea_Plate1Pool2,316005,75,315930,0.0266276931042,0.0208333333333,0.00579436

1. Library: Name of individual / Fastq file. (Mandatory)
2. NumReads: Number of sequence reads for that library. (Mandatory)
3. NumReadsPhix: Number of Phix reads for that library. (Optional)
4. NumReadsGood: NumReads - NumReadsPhix. (Optional)
5. PercentObtained: Proportion of total reads came from this library. (Optional)
6. PercentExpected: Target proportion of reads for library. (Optional)
7. Difference: PercentObtained - PercentExpected. (Optional)

**RemovedReport CSV**: (Optional)

_Suggested name format_: [year][month][day]_[ProjectName]_RemovedReport.csv

    Ambiguous_Barcodes,Low_Quality,Ambiguous_Radtag,Total_Removed
    78455994,0,37433446,115889440
            
1. Ambiguous_Barcodes: Number of reads discarded since their barcodes did not match any in the barcode file. (Mandatory)
2. Low_Quality: Number of reads discarded because of low sequence quality. (Mandatory)
3. Ambiguous_Radtag: Number of reads discarded because the SbfI cut site could not be found. (Mandatory)
4. Total_Removed: Number of reads discarded. (Mandatory)

### Output Files:

**ReadStats CSV**: [year][month][day]_[ProjectName]_ReadStats.csv

    Total Reads,Total Non-Phix,Mean,SD,Median,Mean/Median,Cv,Min Good Read,Max Good Read,Range (Orders of Magnitude)
    11867532,11867532,247240.25,135649.556323278,274612,0.900325732305944,0.548654825916403,2135,646104,2.48090455038451

**PhixStats CSV**: [year][month][day]_[ProjectName]_PhixStats.csv

    Total Phix,Percent Phix,Mean Phix,SD Phix,Median Phix,Mean/Median Phix,Cv Phix
    8458,0.0951474464812488,291.655172413793,233.025178875906,191,1.52699043148583,0.798974957129494

**Sequence Report - markdown**: [year][month][day]_[ProjectName]_SeqReport.md

**Sequence Report - HTML**: [year][month][day]_[ProjectName]_SeqReport.html

**Sequence Report - HTML files (directory)**: [year]-[month]-[day]_[ProjectName]_SeqReport

### Parameters:

**Mandatory**

- -i, --FH_readReport: ReadReport input file CSV
- -p, --prefix: Project name
- -o, --outputDirectory: Output generated files to this directory
- -d, --sequenceDate: Date of sequence run: yyyy-mm-dd
- -f, --fastq_header: A single header from a fastq. Replace spaces with ':' 


**Optional**
- -r, --FH_removedReport: Removed report input file
- -m, --machineType: Type of sequencing machine. EX: HiSeq1000
- -c, --chemistryType: Type of sequencing chemistry

### Todo:

1. Should not require absolute paths
2. Fastq header should be optional, especially as machineType and chemistryType can be optionally provided instead of
3. Cleaner argument longnames 
