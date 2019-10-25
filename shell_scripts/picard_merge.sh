#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-kmj477
#SBATCH --mem=80000M
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL

module load nixpkgs/16.09  intel/2018.3
module load samtools/1.9
module load picard/2.18.9

java -jar $EBROOTPICARD/picard.jar MergeSamFiles \
I=/home/biomatt/scratch/cigar_split/Wall-002_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-005_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-006_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-008_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-011_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-016_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-019_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-020_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-171_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-172_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-173_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-174_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-175_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-176_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-177_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-178_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-182_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-184_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-185_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-187_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-188_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-193_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-196_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-197_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-210_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-212_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-213_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-214_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-215_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-216_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-217_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-218_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-290_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-292_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-294_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-295_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-296_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-297_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-301_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-302_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-343_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-344_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-345_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-349_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-350_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-353_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-354_cigar.bam \
I=/home/biomatt/scratch/cigar_split/Wall-355_cigar.bam \
O=/home/biomatt/scratch/cigar_split/merged_cigar_long.bam

