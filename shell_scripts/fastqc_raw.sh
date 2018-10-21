#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477

module load fastqc

cd /home/biomatt/projects/def-kmj477/biomatt/Raw_Reads
for file in $(pwd | ls)
do
	fastqc -t 2 $file -o /home/biomatt/walleye_rna/raw_reads_quality
done
