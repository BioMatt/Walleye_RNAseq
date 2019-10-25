#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-kmj477
#SBATCH --constraint=skylake
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=0
#SBATCH --array=1-48
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL


module load nixpkgs/16.09  intel/2018.3 
module load star/2.6.1c

starindex="/home/biomatt/projects/def-kmj477/biomatt/star_index2"

indir="/home/biomatt/scratch/Trimmed_Reads/Paired/"

workingdir="/home/biomatt/scratch/walleye_star_aligned_2passmode/"

list=trimmed_read_list.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}" 
str=$($string) 

var=$(echo $str | awk -F"\t" '{print $1, $2}') 
set -- $var 
c1=$1 
c2=$2

echo "$c1" 
echo "$c2"

wall_id=$(echo ${c1} | cut -c1-8)

echo "$wall_id"

mkdir ${workingdir}${wall_id}

outdir=${workingdir}${wall_id}

STAR --runMode alignReads --genomeDir $starindex --readFilesCommand zcat \
--twopassMode Basic --twopass1readsN -1 \
--outTmpDir /home/biomatt/scratch/${wall_id} \
--readFilesIn ${indir}${c1} ${indir}${c2} \
--sjdbFileChrStartEnd /home/biomatt/projects/def-kmj477/biomatt/star_array_filed/${wall_id}/${wall_id}SJ.out.tab \
--sjdbOverhang 99 \
--runThreadN $SLURM_CPUS_PER_TASK \
--outFileNamePrefix ${outdir}/${wall_id} \
--outSAMtype BAM Unsorted
