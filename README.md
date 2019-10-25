# Walleye RNA sequencing and analysis
#### This repository covers the pipeline used for analyzing the full transcriptomes of 48 female walleye from Lake Winnipeg, caught in 2017 and 2018. These samples were sequenced on an Illumina NovaSeq 6000 with 2,170,826,311 reads and 438,506,914,822 bases observed. 

#### Generally, the analysis pipeline covers:
## Shell scripts:
#### -Running FASTQC for checking the quality of raw reads
#### -Using trimmomatic/0.36 to trim adaptors and poor quality nucleotides from the data
#### -Running FASTQC again, on the trimmed reads
#### -Using Salmon for read counts 
#### -Using Bowtie2 for quality assurance by aligning reads to the transcriptome and checking alignment rate
#### -Using Star to align read to align trimmed reads to a Lace-clustered transcriptome
#### -Picard for processing Star-aligned bam files for SNP calling
#### -FreeBayes run in parallel for SNP calling
