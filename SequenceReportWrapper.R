library("rmarkdown")
suppressPackageStartupMessages(require(optparse)) 

options_list = list (
  make_option ( c ("-i", "--FH_readReport"), action="store", default="", type='character',
                help="Read report input file"),
  make_option ( c ("-r", "--FH_removedReport"), action="store", default="", type='character',
                help="Removed report input file"),
  make_option ( c ("-o", "--outputDirectory"), action="store", default="", type='character',
                help="Output generated files to this directory"),
  make_option ( c ("-p", "--prefix"), action="store", default="", type='character',
                help="Project name"),
  make_option ( c ("-d", "--sequenceDate"), action="store", default="", type='character',
                help="Date of sequence run: yyyy-mm-dd"),
  make_option ( c ("-f", "--fastq_header"), action="store", default="", type='character',
                help="A single header from a fastq. Replace spaces with ':'"),
  make_option ( c ("-m", "--machineType"), action="store", default="", type='character',
                help="Type of sequencing machine. EX: HiSeq1000"),
  make_option ( c ("-c", "--chemistryType"), action="store", default="", type='character',
                help="Type of sequencing chemistry")
)

opt = parse_args(OptionParser(option_list=options_list))

print (opt)

##### Example Arguments #####
# FH_readReport <- "/home/krell/Documents/SequenceReports/newfmt/2017-03-15_FDA_ReadReport.csv"
# FH_removedReport <- "/home/krell/Documents/SequenceReports/newfmt/2017-03-15_FDA_RemovedReport.csv"
# prefix <- "FDA"
# sequenceDate <- "2017-03-15"
# fastq_header <- "@K00291:43:HJFFCBBXX:7:1101:2260:1261 1:N:0:NATCAG"
# machineType = "HiSeq4000"
# outputDirectory = "/home/krell/Documents/SequenceReports/newfmt/"

#FH_readReport <- args[1]
#FH_removedReport <- args[2]
#prefix <- args[3]
#sequenceDate <- args[4]
#fastq_header <- args[5]
#outputDirectory = args[6]
#machineType = args[7]


FH_readReport <- "/media/Wapuilani/evan/repo/SequenceReportGenerator/test/FDA-Buffalo-Hiseq2_ReadReport.csv"
FH_removedReport <- "/media/Wapuilani/evan/repo/SequenceReportGenerator/test/FDA-Buffalo-Hiseq2_RemovedReport.csv"
prefix <- "FDA-Buffalo-Hiseq2"
sequenceDate <- "UnkownDate"
fastq_header <- "@K00291:43:HJFFCBBXX:7:1101:2260:1261 1:N:0:NATCAG"
outputDirectory <- "/media/Wapuilani/evan/repo/SequenceReportGenerator/test/out/"
machineType <- "HiSeq4000"



FH_readReport = opt$FH_readReport
FH_removedReport = opt$FH_removedReport
prefix = opt$prefix
sequenceDate = opt$sequenceDate
fastq_header = opt$fastq_header 
outputDirectory = opt$outputDirectory
machineType = opt$machineType
chemistryType = opt$chemistryType



if (sub('.*(?=.$)', '', outputDirectory, perl=T) == "/") {
  path <- paste (outputDirectory, sequenceDate, sep = "")
} else {
  path <- paste (outputDirectory, sequenceDate, sep = "/")
}

handle_prefix = paste (path, prefix, sep = "_")

renderSequenceReport <- function (FH_readReport, FH_removedReport, prefix, sequenceDate, fastq_header, outputDirectory, machineType, chemistryType) {
  rmarkdown::render("/media/Wapuilani/evan/repo/SequenceReportGenerator/SequenceReportGenerator.Rmd", 
    
  params = list(
      FH_readReport = FH_readReport, 
      FH_removedReport = FH_removedReport, 
      prefix = prefix, 
      sequenceDate = sequenceDate, 
      fastq_header = fastq_header, 
      outputDirectory = outputDirectory,
      machineType = machineType,
      chemistryType = chemistryType
  ),
  output_file = paste (handle_prefix, "SeqReport.html", sep = "_")
  
  )
}

renderSequenceReport(
  FH_readReport,
  FH_removedReport,
  prefix,
  sequenceDate,
  fastq_header,
  outputDirectory,
  machineType,
  chemistryType
)
