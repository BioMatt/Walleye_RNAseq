#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=124000M
# Set up the slurm requests and load FastQC
module load fastqc

# Change the working directory to wherever the raw RNA reads are stored
cd /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired
# For every file in that directory, check its quality using fastqc
for file in $(pwd | ls)
do
	fastqc -t 4 $file -o /home/biomatt/walleye_rna/trimmed_reads_quality
done
