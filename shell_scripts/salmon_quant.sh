#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=12000M
#SBATCH --array=1-48

module load nixpkgs/16.09  gcc/5.4.0  openmpi/2.1.1
module load salmon/0.9.1


list=trimmed_read_list.txt
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}" 
str=$($string) 

var=$(echo $str | awk -F"\t" '{print $1, $2}') 
set -- $var 
c1=$1 
c2=$2

echo "$c1" 
echo "$c2"


salmon quant -i /home/biomatt/projects/def-kmj477/biomatt/walleye_salm_index -l IU \
-1 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c1} \
-2 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c2} \
-o /home/biomatt/projects/def-kmj477/biomatt/salm_outputs/salm_output_${c1}
