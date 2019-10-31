# This script is for making a Colony input file, using the output from Daniel Water's VCF converter to Colony script 
# (https://github.com/dandewaters/VCF-File-Converter)
# and a Colony marker file as inputs, which then outputs a .dat file for use with the command-line version of Colony. 
# Creating the 3 lines Colony likes for its marker file
# One, with two columns for each SNP, and 52,372 SNPs to start with, create 1 through 104,744 as SNP names
markers <- 1:104744
# Use 1 for dominant markers
marker_type <- rep("1", 104744)
# Allelic dropout rate, which we are assuming is 0 for these SNPs
allelic_dropout <- rep("0", 104744)
# Since these SNPs were filtered by Phred quality 30, try using 0.001 as an error rate
error_rate <- rep("0.001", 104744)

# Bind these lines and write them to a text file for Colony
marker_output <- rbind(markers, marker_type, allelic_dropout, error_rate)
write.table(marker_output, "wall_colony_markers.txt", quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)



####################################################################################
#
# SAMPLING OFFSPRING FROM A COLONY INPUT THAT INCLUDES ALL OFFPSRING
#
# Created by MA on 8/26/14
# Modified by M.Thorstensen March 1, 2018, then again on June 9, 2019 for use with RNA SNPs
# Removed the ability to subsample offspring iteratively, added uniform random number generator for Colony seed values, added the ability to input a Colony marker file instead of listing genotypes as the markers for the .dat output file
#

# On 6/9/19, took out the for loop to create multiple .dat files with different random number seeds. Instead, this now creates a single .dat file
####################################################################################
# SET UP THE R-ENVIRONMENT
# There are five changes to make when creating .dat files for a new set of Colony runs
# 1. Setting your working directory 
# 2. Filling in the name of your genotype file, formatted for input to the Colony GUI, 
# 3. Filling in the name of your marker file, also formatted for the Colony GUI
# 4. Choosing how many .dat files to make, under 'iterations'
# 5. Changing the 'group' which affects the output files and Colony project names


allOffspring <- read.table("colLD_prune_seq_array.txt")
marker_file <- read.table("wall_colony_markers.txt")

# The prefix for my .dat files
group <- "walleye"

offspring <- allOffspring[]
#filename  <- paste("output/pahs_",nrow(offspring),"_",z,".txt", sep = "")
filename  <- paste("output",group,"_",nrow(offspring),".dat", sep = "")
directory <- paste("output",group,"_",nrow(offspring), sep = "")

### WRITE HEADER
write(paste("'",directory,"'",sep=""), file = filename, append = FALSE, sep = "")
write(paste("'",directory,"'",sep=""), file = filename, append = TRUE, sep = "")
write(paste(nrow(offspring),"! Number of offspring in the sample",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste((ncol(offspring)-1),"! Number of loci",sep = "\t"), file = filename, append = TRUE, sep = "\t")
# this script for a random number between 0 and 100000 is for seed value Colony uses. Just change it to 1234 if you want to go with the default Colony value, but if you do, every Colony run based on this script will be the same!
write(paste(as.integer(runif(1,1,100000)),"! Seed for random number generator",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(1,"! 0/1=Not updating/updating allele frequency",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(2,"! 2/1=Dioecious/Monoecious species",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(1,"! 0/1=Inbreeding absent/present",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(0,"! 0/1=Diploid species/HaploDiploid species",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste("0  0","! 0/1=Polygamy/Monogamy for males & females",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(0,"! 0/1 = Clone inference = No/Yes"), file = filename, append = TRUE, sep = "\t")
write(paste(1,"! 0/1=Scale full sibship=No/Yes"), file = filename, append = TRUE, sep = "\t")
write(paste(0,"! 0/1/2/3=No sibship prior/Weak sibship prior/Medium sibship prior/Strong sibship prior",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(0,"! 0/1=Unknown/Known population allele frequency",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(10,"! Number of runs",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(2,"! 1/2/3/4 = Short/Medium/Long/VeryLong run",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(0,"! 0/1=Monitor method by Iterate#/Time in second",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(10000,"! Monitor interval in Iterate# / in seconds",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(0,"! 0/1=DOS/Windows version",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(1,"! 0/1/2=Pair-Likelihood-Score(PLS)/Full-Likelihood(FL)/FL-PLS-combined(FPLS) method",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write(paste(2,"! 0/1/2/3=Low/Medium/High/VeryHigh precision",sep = "\t"), file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)

### WRITE MARKER INFO
write.table(marker_file, file = filename, sep = ",", row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
write("", file = filename, append = TRUE)


### WRITE SNP DATA
write.table(allOffspring, file = filename, sep = " ", row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
write("", file = filename, append = TRUE)

### WRITE TAILER
write("0.0  0.0", file = filename, append = TRUE, sep = "\t")
write("0  0", file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write("", file = filename, append = TRUE)
write("0  0", file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write("0  0", file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(0, file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(0, file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(0, file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(0, file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(0, file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(0, file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write("", file = filename, append = TRUE)
write("!____________NOTE____________!",file = filename, append = TRUE, sep = "\t")
write("", file = filename, append = TRUE)
write(paste("Input file",filename,"generated by sampling_offspring.r code written by MA on 8/27/14, modified by M.Thorstensen 3/1/18, then by M.Thorstensen on 6/9/19"),file = filename, append = TRUE, sep = "")
write(paste("Generated by",Sys.getenv("USERNAME"),"on",Sys.time()),file = filename, append = TRUE, sep = "")