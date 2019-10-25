#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=80000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

module load nixpkgs/16.09  intel/2018.3
module load samtools/1.9
module load picard/2.18.9

java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R=/home/biomatt/projects/def-kmj477/biomatt/Lace_files_annotated/walleye_lace.fasta \
O=/home/biomatt/projects/def-kmj477/biomatt/Lace_files_annotated/walleye_lace.dict
