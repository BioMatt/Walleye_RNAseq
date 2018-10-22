#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=8000M

module load nixpkgs/16.09  gcc/5.4.0  openmpi/2.1.1
module load salmon/0.9.1
# Load up the salmon program and all its dependancies, then run salmon in indexing mode on a transcriptome
# This will give us an index directory where salmon will refer to when counting up transcript reads
salmon index -t /home/biomatt/projects/def-kmj477/biomatt/Transcriptome/walleye_transcriptome.fa -i walleye_index --type quasi -k 31
