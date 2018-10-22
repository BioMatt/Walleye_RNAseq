#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=12000M
#SBATCH --array=1-48
# This script creates an array, loads salmon version 0.9.1, and its dependant packages, and runs salmon on all the files specified
# In the trimmed_read_list.txt file
module load nixpkgs/16.09  gcc/5.4.0  openmpi/2.1.1
module load salmon/0.9.1

# This is a text file of the R1 and R2 file names dropped into the same directory as this shell script.
# I simply made it by making a tab spaced value file with R1 and R2 file names for each sample next to each other
list=trimmed_read_list.txt
# This line grabs a R1 R2 file name pair from the list based on the array ID
string="sed -n "$SLURM_ARRAY_TASK_ID"p ${list}" 
str=$($string) 

# Find the two file names and take the tab delimitation off
var=$(echo $str | awk -F"\t" '{print $1, $2}') 
set -- $var 
# Set variables to the R1 and R2 file names
c1=$1 
c2=$2

# List these files in the slurm output to see what slurm was working on
echo "$c1" 
echo "$c2"

# Actially run salmon, using these file names
salmon quant -i /home/biomatt/projects/def-kmj477/biomatt/walleye_salm_index -l IU \
-1 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c1} \
-2 /home/biomatt/projects/def-kmj477/biomatt/Trimmed_Reads/Paired/${c2} \
-o /home/biomatt/projects/def-kmj477/biomatt/salm_outputs/salm_output_${c1}
