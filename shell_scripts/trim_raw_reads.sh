#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --array=1-48
#SBATCH --mem=24000M
# This script runs trimmomatic/0.36 in an array across 48 individuals with paired-end reads
# Set up the memory and time requested
# Load java and trimmomatic
module load java
module load trimmomatic/0.36

# Create a directory variable for where I'm pulling the raw read files from
dir=/home/biomatt/projects/def-kmj477/biomatt/Raw_Reads/
# Similarly, create a directory variable for placing the trimmomatic outputs
out_dir=/home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/

# This creates a list of all files in my directory, but only searches for the ones that end with R1, so the R2 or reverse reads 
# are not included. 
files=(${dir}*_R1.fastq.gz)

# From the list of R1 files from the "files" variable, pull a single R1 file based on where in the array slurm is going through.
file=${files[${SLURM_ARRAY_TASK_ID}]}

# Take one single file from the array, and find it's base name, stripping off the directory and everything at _R1 and after
name=`basename $file _R1.fastq.gz`
# Check that things worked so far. Plus, the slurm output handily tells you which file it worked on in the array.
echo ${name}

# Run trimmomatic in paired end mode on the single file from the array, taking the base name and running it on R1 and R2 
# for the forward and reverse reads. Then, set the 4 program outputs to the output directory.
# Finally, use the Illumina TruSeq3-PE-2 fasta file for clipping reads (also included in this git repository), 
# set the leading and trailing Phred score thresholds to 5,
# a sliding window threshold of 4 nucleotides averaging 5 phred overall, and trimming for a minimum read length of 36
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar PE \
${dir}${name}_R1.fastq.gz ${dir}${name}_R2.fastq.gz \
${out_dir}${name}_R1_paired.fq.gz ${out_dir}${name}_R1_unpaired.fq.gz \
${out_dir}${name}_R2_paired.fq.gz ${out_dir}${name}_R2_unpaired.fq.gz \
ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:5 MINLEN:36

