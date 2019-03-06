## Genomics Core Lab Procedures

This document describes how the use the Sequence Report Generator with your data as a member of GCL. 
Other users could read this document to get an idea for how it is being used. 

**Infrastructure**

The current version of this repository is stored on the TAMUCC HPC in:

    /work/hobi/GCL/scrips/SequenceReportGenerator

## Generate Report:

**if demultiplexed:**

1. Use cntPhix.sh to get the files NumTotalReads.txt and NumPhixReads.txt
2. Make sure the libraries are listed in the same order in the demultiplex file and NumTotalReads.txt and NumPhixReads.txt (Use sort command if need be)
3. Generate the ReadReport csv:

	```
	bash /work/hobi/GCL/scripts/SequenceReportGenerator/GCL_procedures/buildReadReport.sh \
		<yyyymmdd>_<ProjectName> <path to NumTotalReads.txt> <path to NumPhixReads.txt> <path to demultiplex file>
	```

4. Generate the RemovedReport csv:

	```
	bash /work/hobi/GCL/scripts/SequenceReportGenerator/GCL_procedures/buildRemovedReport.sh \
		<path to process radtags logfile> > <yyyymmdd>_<ProjectName>_RemovedReport.csv
	```

5. Generate the sequence report:
	
	```
        module load R/gcc/64/3.3.2

        Rscript /work/hobi/GCL/scripts/SequenceReportGenerator/SequenceReportWrapper.R -i <absolute path to ReadReport CSV> \
        -r <absolute path to RemovedReport CSV> \
        -p <project name> -d <date sequenced> -f <header> \
        -o <output directory>
	```

**if not demultiplexed:**

This is a more general case. You may be dealing with pools, ezRAD data, or various subsets such as a particular lane. 
The percent obtained and expected depends on the context and cannot be decided automatically. 
For example, you may have only one lane in the report but want the percent to be across all lanes.
Further, the expected percent is not normally 1/total, but instead depends on the sequence run. 
You need to find this information to create the columns PercentObtained, PercentExpected, and Difference yourself if
you want to include that optional information. 

1. Use cntPhix.sh to get the files NumTotalReads.txt and NumPhixReads.txt
2. Generate the ReadReport csv:
	
	```
	bash /work/hobi/GCL/scripts/SequenceReportGenerator/GCL_procedures/buildReadReport.sh \
		<yyyymmdd>_<ProjectName> <path to NumTotalReads.txt> <path to NumPhixReads.txt>
	```

3. (Optional) Determine PercentExpected, PercentObtained, and Difference by understanding your sequence context
5. Generate the sequence repoort

	```
	module load R/gcc/64/3.3.2

	Rscript /work/hobi/GCL/scripts/SequenceReportGenerator/SequenceReportWrapper.R -i <absolute path to ReadReport CSV> \
	-p <project name> -d <date sequenced> -f <header> \
	-o <output directory>
	```

