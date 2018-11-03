#!/bin/bash
#SBATCH --time=08:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=24000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

# Set up slurm options and ask the cluster to email me when the program starts, stops, or errors out.

# All of these modules are required for bowtie2 on this cluster. They're just the ones pulled from the command
# module spider bowtie2/2.3.4.1 on the command line.
module load nixpkgs/16.09  intel/2016.4

module load bowtie2/2.3.4.1

# Build the actual bowtie index, using "walleye" as the prefix for the various index files. They get created 
# at the same directory the script is.
bowtie2-build /home/biomatt/projects/def-kmj477/biomatt/Transcriptome/walleye_transcriptome.fa walleye
