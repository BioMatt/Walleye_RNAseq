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

workingdir="/home/biomatt/scratch"

list=wall_dir.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}" 
str=$($string) 

var=$(echo $str | awk -F"\t" '{print $1}') 
set -- $var 
c1=$1 

echo "$c1" 

java -jar $EBROOTPICARD/picard.jar \
MarkDuplicates \
I=${workingdir}/rg_sorted_bam/${c1}_rg_sorted.bam \
O=${workingdir}/markdup_bam/${c1}_pic_markdup.bam \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=SILENT \
M=${workingdir}/markdup_bam/${c1}_metrics.txt
