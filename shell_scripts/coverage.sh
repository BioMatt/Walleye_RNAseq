#!/bin/bash
#SBATCH --account=def-kmj477
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL
#SBATCH --constraint=broadwell
#SBATCH --mem=0
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=200:00:00

module load nixpkgs/16.09 intel/2018.3
module load bamtools/2.4.1

bamtools coverage -in /home/biomatt/scratch/cigar_split/merged_cigar.bam -out /home/biomatt/scratch/merged_cigar_coverage_long.bam