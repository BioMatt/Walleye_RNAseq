#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --array=1-48
#SBATCH --mem=24000M

module load java
module load trimmomatic/0.36

dir=/home/biomatt/projects/def-kmj477/biomatt/Raw_Reads/
out_dir=/home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/
files=(${dir}*_R1.fastq.gz)


file=${files[${SLURM_ARRAY_TASK_ID}]}

name=`basename $file _R1.fastq.gz`
echo ${name}

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar PE \
${dir}${name}_R1.fastq.gz ${dir}${name}_R2.fastq.gz \
${out_dir}${name}_R1_paired.fq.gz ${out_dir}${name}_R1_unpaired.fq.gz \
${out_dir}${name}_R2_paired.fq.gz ${out_dir}${name}_R2_unpaired.fq.gz \
ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:5 MINLEN:36

