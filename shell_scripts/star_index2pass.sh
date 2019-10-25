#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=64000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

module load nixpkgs/16.09 intel/2018.3
module load star/2.6.1c

starindex="/home/biomatt/projects/def-kmj477/biomatt/star_index2pass"

STAR --runMode genomeGenerate --runThreadN 4 --genomeDir $starindex \
--genomeFastaFiles /home/biomatt/projects/def-kmj477/biomatt/Lace_files_annotated/walleye_lace.fasta \
--sjdbGTFfile /home/biomatt/projects/def-kmj477/biomatt/Lace_files_annotated/walleye_lace_trans.gff \
--sjdbFileChrStartEnd /home/biomatt/projects/def-kmj477/biomatt/star_index2/SJ.out.tab \
--sjdbOverhang 75 \
--limitGenomeGenerateRAM 64000000000 \
--limitIObufferSize 16000000000 \
--genomeChrBinNbits 12

