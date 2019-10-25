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

indir="/home/biomatt/scratch/cleaned_bam/"

list=wall_dir.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}" 
str=$($string) 

var=$(echo $str | awk -F"\t" '{print $1}') 
set -- $var 
wall_id=$1 

echo "$wall_id"

outdir="/home/biomatt/scratch/rg_sorted_bam/"

rg_id=read_group_id.txt
rg_string="sed -n "$SLURM_ARRAY_TASK_ID"p ${rg_id}"
rg_str=$($rg_string)

echo "$rg_str"

java -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups I=${indir}${wall_id}_cleaned.bam O=${outdir}${wall_id}_rg_sorted.bam \
SO=coordinate RGID=${rg_str} RGLB=mRNA_789 RGPL=ILLUMINA RGPU=Illumina_NovaSeq_6000_S2_PE100 RGSM=${wall_id}
