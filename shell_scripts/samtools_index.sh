#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=80000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

module load nixpkgs/16.09  intel/2018.3
module load samtools/1.9
module load picard/2.18.9

samtools index /home/biomatt/scratch/cigar_split/merged_cigar_long.bam