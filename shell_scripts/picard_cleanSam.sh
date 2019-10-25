#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=80000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-48

module load nixpkgs/16.09  intel/2018.3
module load samtools/1.9
module load picard/2.18.9

indir="/home/biomatt/scratch/star_aligned_2pass/"

list=wall_dir.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1}')
set -- $var
wall_id=$1

echo "$wall_id"

outdir="/home/biomatt/scratch/cleaned_bam/"

java -jar $EBROOTPICARD/picard.jar CleanSam I=${indir}${wall_id}/${wall_id}Aligned.out.bam O=${outdir}${wall_id}_cleaned.bam
