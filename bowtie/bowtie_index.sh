#!/bin/bash
#SBATCH --time=08:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=24000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

module load nixpkgs/16.09  intel/2016.4

module load bowtie2/2.3.4.1

bowtie2-build /home/biomatt/projects/def-kmj477/biomatt/Transcriptome/walleye_transcriptome.fa walleye
