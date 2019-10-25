#!/bin/bash
#SBATCH --account=def-kmj477
#SBATCH --mail-user=thorstem@myumanitoba.ca
#SBATCH --mail-type=ALL
#SBATCH --time=12:00:00
#SBATCH --constraint=broadwell
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=0

module load nixpkgs/16.09 intel/2018.3
module load corset/1.07


corset -D 99999999999 -g 1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3 \
-n Wall-002,Wall-005,Wall-006,Wall-008,Wall-011,Wall-016,Wall-019,Wall-020,Wall-171,Wall-172,\
Wall-173,Wall-174,Wall-175,Wall-176,Wall-177,Wall-178,Wall-182,Wall-184,Wall-185,Wall-187,Wall-188,\
Wall-193,Wall-196,Wall-197,Wall-210,Wall-212,Wall-213,Wall-214,Wall-215,Wall-216,Wall-217,Wall-218 \
Wall-290,Wall-292,Wall-294,Wall-295,Wall-296,Wall-297,Wall-301,Wall-302,Wall-343,Wall-344,Wall-345 \
Wall-349,Wall-350,Wall-353,Wall-354,Wall-355 \
-i salmon_eq_classes /home/biomatt/projects/def-kmj477/biomatt/walleye_rna/salm_quants_corset/salm_output_*/aux_info/eq_classes.txt \
-p /home/biomatt/scratch/walleye_rna/walleye_corset