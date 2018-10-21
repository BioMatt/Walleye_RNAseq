# Walleye_RNAseq
#### This repository covers the pipeline used for analyzing the full transcriptomes of 48 female walleye from Lake Winnipeg, caught in 2017 and 2018. These samples were sequenced on an Illumina NovaSeq 6000 with 2,170,826,311 reads and 438,506,914,822 bases observed. 

#### Generally, the analysis pipeline covers:
#### -Running FASTQC for checking the quality of raw reads
#### -Using trimmomatic/0.36 to trim adaptors and poor quality nucleotides from the data
#### -Running FASTQC again, on the trimmed reads
#### -Using Salmon for read counts 
