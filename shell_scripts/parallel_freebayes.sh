#!/bin/bash
#SBATCH --time=672:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=0
#SBATCH --cpus-per-task=36
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL
#SBATCH --constraint=skylake
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --propagate=STACK


# Before running this script, in linux use ulimit -n 2024 and ulimit -s 102400
module load nixpkgs/16.09  intel/2018.3
module load bamtools/2.4.1
module load gcc/7.3.0 freebayes/1.2.0

refdir="/home/biomatt/projects/def-kmj477/biomatt/Lace_files_annotated/"

outdir="/home/biomatt/scratch/"

/home/biomatt/walleye_rna/freebayes-parallel ref.fa.10000.regions \
$SLURM_CPUS_PER_TASK -f ${refdir}walleye_lace.fasta \
/home/biomatt/scratch/cigar_split/merged_cigar_long.bam >${outdir}wall_snps_cigar_parallel_28day.vcf
