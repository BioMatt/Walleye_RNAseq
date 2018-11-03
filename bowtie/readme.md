These files are either scripts or outputs for running Bowtie2 on the same transcriptome used to make the Salmon index and the 
trimmed reads that Salmon quantified. This little pipeline was intended to mostly be used for quality assurance, to make sure that
the reads aligned to the transcriptome at a reasoable frequency. They did, and in the slurm outputs folder you can see the slurm
files that report the overall alignment rate that Bowtie2 found for each walleye.

The two scripts are for 1) creating a Bowtie2 index from the transcriptome, and 2) aligning reads to that index. The index outputs,
trimmed read inputs, and .sam files of aligned transcripts are too large to upload to GitHub.
