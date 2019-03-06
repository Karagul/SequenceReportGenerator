# Gets information about sequence run from an Illumina Fastq Header

library ("stringr")

getMachineType <- function (x) {
	machineType = "Unknown"
	if (length (grep ("HWI-M0....", x) > 0)) {
		machineType = "MiSeq"
	}
	else if (length (grep ("HWI-S....", x) > 0)) {
		machineType = "HiSeq(2000)"
	}
	else if (length (grep ("HWI-D....", x) > 0)) {
		machineType = "HiSeq(2500)"
	}
	else if (length (grep ("@M....", x) > 0)) {
		machineType = "MiSeq"
	}
	else if (length (grep ("HWUSI", x) > 0)) {
		machineType = "GALLx"
	}
	else if (length (grep ("@HWI-M....", x) > 0)) {
		machineType = "MiSeq"
	}
	else if (length (grep ("@HWI-D....", x) > 0)) {
		machineType = "HiSeq(2000/2500)"
	}
	else if (length (grep ("@K.....", x) > 0)) {
		machineType = "HiSeq(3000?/4000)"
	}
	else if (length (grep ("@N.....", x) > 0)) {
		machineType = "NextSeq(500/550)"
	}

	machineType
}

getChemistryType <- function (flowcellID) {
	x <- str_sub (flowcellID, start = -4)
	chemistryType = "Unknown"
	if (length (grep ("AA..", x) > 0)) {
		chemistryType = "GenomeAnalyzer"
	}
	else if (length (grep ("BC..", x) > 0)) {
		chemistryType = "HiSeq(v1.5)"
	}
	else if (length (grep ("AC..", x) > 0)) {
		chemistryType = "HiSeq_HighOuput(v3)"
	}
	else if (length (grep ("AN..", x) > 0)) {
		chemistryType = "HiSeq_HighOutput(v4)"
	}
	else if (length (grep ("AD..", x) > 0)) {
		chemistryType = "HiSeq_RR(v1)"
	}
	else if (length (grep ("((AM)|(BC))..", x) > 0)) {
		chemistryType = "HiSeq_RR(v2)"
	}
	else if (length (grep ("AF..", x) > 0)) {
		chemistryType = "NextSeq_MidOutput"
	}
	else if (length (grep ("AL..", x) > 0)) {
		chemistryType = "HiSeqX"
	}
	else if (length (grep ("((BG)|(AG))..", x) > 0)) {
		chemistryType = "NextSeq_HighOutput"
	}

	chemistryType
}

getFASTQtable <- function (fastqHeader) {
	# Only applies to FASTQ format since Casava 1.8, inclusive
	format <- c ("InstrumentName", "RunID", "FlowcellID", "Lane", "LaneNum", "X-Coord", "Y-Coord", "PairIndex", "Filtered", "CtrlBits", "SeqIdx") 

	fqStr <- gsub (" ", ":", fastq_header)
	fqTbl <- strsplit (fqStr, split = ":", fixed = TRUE)
	fqTbl <- data.frame (do.call (rbind, fqTbl), stringsAsFactors = FALSE)
	
	colnames (fqTbl) <- format
	fqTbl
	
}	
