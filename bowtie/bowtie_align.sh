#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=24000M
#SBATCH --array=1-48
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

module load nixpkgs/16.09 intel/2016.4

module load bowtie2/2.3.4.1

list=trimmed_read_list.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}"
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')
set -- $var
c1=$1
c2=$2

echo "$c1"
echo "$c2"

bowtie2 -q --phred33 -x walleye -1 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c1} \
-2 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c2} \
-S /home/biomatt/projects/def-kmj477/biomatt/bowtie_aligned/${c1}.sam


