#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=24000M
#SBATCH --array=1-48
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

# This is an array job, just like the script that asked Salmon to quantify the trimmed reads. The bowtie2 module dependences
# are the same as in the bowtie index script, learned from using module spider bowtie2/2.3.4.1

module load nixpkgs/16.09 intel/2016.4

module load bowtie2/2.3.4.1

# The trimmed read list is the same as that used for the Salmon quantification script.
list=trimmed_read_list.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')
set -- $var
c1=$1
c2=$2

echo "$c1"
echo "$c2"

# Actually calling Bowtie2 for aligning reads to the transcriptome. -1 and -2 options are for the forward and reverse reads,
# -S shows Bowtie2 what to name the .sam file outputs and where to place them, -x walleye tells the program what the index file
# prefixes are named, and --phred33 tells Bowtie2 that quality scores are Phred33, not Phred64. One thing is that the Bowtie2 
# index files have to be in the same directory as this script, the way it is written, for it to find them.
bowtie2 -q --phred33 -x walleye -1 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c1} \
-2 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c2} \
-S /home/biomatt/projects/def-kmj477/biomatt/bowtie_aligned/${c1}.sam


