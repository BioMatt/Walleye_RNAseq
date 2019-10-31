# Looking at Fst with just LD Pruned snps
library(hierfstat)
library(vcfR)
library(tidyverse)

# Reading the LD-pruned HWE vcf
LD_prune_wall <- read.vcfR("LD_prune_seq_array.vcf")

# Reformatting the vcfR object into a genlight object
LD_prune_wall <- vcfR2genlight(LD_prune_wall)

# Reformatting this to a matrix for input into hierfstat
LD_prune_wall <- as.matrix(LD_prune_wall)

# Prepare 0, 1, 2 matrix in hierfstat format
# Use locations to test for population differentiation
hf_LD <- LD_prune_wall
hf_LD[hf_LD==0] <- 11
hf_LD[hf_LD==1] <- 12
hf_LD[hf_LD==2] <- 22

# Read in the adegenet population assignments
adgenet_assignments <- read_delim("adegenet_pop_assignments.txt", delim = "\t")

# Reordering the adgenet assignment tibble to match the order of individuals in the hierfstat matrix
adgenet_assignments <- adgenet_assignments[match(row.names(hf_LD), adgenet_assignments$Sample_ID),]

# Sticking on the reassigned populations from adgenet into the hierfstat data frame
hf_LD <- as.data.frame(cbind(adgenet_assignments$assigned.pop.2clusters, hf_LD))
View(hf_LD[,1:2])

# Resorting the data frame to keep Ne Estimator V2 happy
hf_LD <- hf_LD[order(hf_LD$V1),]

# Write an fstat file for use with Ne Estimator V2
write.fstat(hf_LD, "adegenet_assignment_neutral_wall.dat")


# Looking at pairwise Fst with hierfstat
LD_prune_wc_fst <- pairwise.WCfst(hf_LD, diploid = TRUE)
LD_prune_wc_fst
LD_prune_bootstrap_confidence <- boot.ppfst(dat = hf_LD, nboot = 1000)
LD_prune_bootstrap_confidence$ll
LD_prune_bootstrap_confidence$ul

LD_prune_basic.stats <- basic.stats(hf_LD, diploid = TRUE)
LD_prune_basic.stats$overall

boot_fis <- boot.ppfis(hf_LD, nboot = 1000, diploid = TRUE)

# Looking at basic stats for each of pop 1 (Red River + Matheson) and pop 2 (Dauphin River)
hf_LD_South <- hf_LD[hf_LD[, "V1"] == 1]
hf_LD_North <- hf_LD[hf_LD[, "V1"] == 2]

South_basic.stats <- basic.stats(hf_LD_South, diploid = TRUE)
North_basic.stats <- basic.stats(hf_LD_North, diploid = TRUE)

South_basic.stats$overall
North_basic.stats$overall

# Trying Fst again, but instead with the 3 populations assigned my adgenet
pop3_hf_LD <- LD_prune_wall
pop3_hf_LD[pop3_hf_LD==0] <- 11
pop3_hf_LD[pop3_hf_LD==1] <- 12
pop3_hf_LD[pop3_hf_LD==2] <- 22

# Sticking on the reassigned populations from adgenet into the hierfstat data frame
pop3_hf_LD <- as.data.frame(cbind(as.factor(adgenet_assignments$assigned.pop.3clusters), pop3_hf_LD))
View(pop3_hf_LD[,1:2])

# Looking at pairwise Fst with hierfstat
pop3_LD_prune_wc_fst <- pairwise.WCfst(pop3_hf_LD, diploid = TRUE)
pop3_LD_prune_wc_fst

# Resorting the 3 population reassigned data frame to work with boot.ppfst
pop3_hf_LD <- pop3_hf_LD[order(pop3_hf_LD$V1),]

# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 reassigned populations
pop3_LD_prune_bootstrap_confidence <- boot.ppfst(dat = pop3_hf_LD, nboot = 1000, diploid = TRUE)
pop3_LD_prune_bootstrap_confidence$ll
pop3_LD_prune_bootstrap_confidence$ul


# Now, using collection site as opposed to reassigned populations to calculate Fst
# Site is already included, but also adding a column where 1 represents Red River + Matheson combined, and 2 represents the Dauphin River
adgenet_assignments$North_South <- rep(c("1", "1", "2"), times = 16)

# Using Hierfstat for Fst among all 3 sites
site_HF_LD <- LD_prune_wall
site_HF_LD[site_HF_LD==0] <- 11
site_HF_LD[site_HF_LD==1] <- 12
site_HF_LD[site_HF_LD==2] <- 22

# Sticking on the collection sites into the hierfstat data frame
site_HF_LD <- as.data.frame(cbind(as.numeric(as.factor(adgenet_assignments$Location)), site_HF_LD))
View(site_HF_LD[,1:2])

# Resorting the site info data frame to work with boot.ppfst
site_HF_LD <- site_HF_LD[order(site_HF_LD$V1),]
View(site_HF_LD[,1:2])

# Looking at pairwise Fst with hierfstat
site_LD_prune_wc_fst <- pairwise.WCfst(site_HF_LD, diploid = TRUE)
site_LD_prune_wc_fst


# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 reassigned populations
site_LD_prune_bootstrap_confidence <- boot.ppfst(dat = site_HF_LD, nboot = 1000, diploid = TRUE)
site_LD_prune_bootstrap_confidence$ll
site_LD_prune_bootstrap_confidence$ul


# Looking at Fst between the North and South basin fish
north.south_HF_LD <- LD_prune_wall
north.south_HF_LD[north.south_HF_LD==0] <- 11
north.south_HF_LD[north.south_HF_LD==1] <- 12
north.south_HF_LD[north.south_HF_LD==2] <- 22

# Sticking on the north/south basin info into the hierfstat data frame
north.south_HF_LD <- as.data.frame(cbind(as.numeric(adgenet_assignments$North_South), north.south_HF_LD))
View(north.south_HF_LD[,1:2])

# Resorting the north/south populations to work with boot.ppfst
north.south_HF_LD <- north.south_HF_LD[order(north.south_HF_LD$V1),]
View(north.south_HF_LD[,1:2])

# Looking at pairwise Fst with hierfstat
north.south_LD_prune_wc_fst <- pairwise.WCfst(north.south_HF_LD, diploid = TRUE)
north.south_LD_prune_wc_fst


# Looking at bootstrapped confidence intervals over 1000 iterations using the North versus South groups
north.south_LD_prune_bootstrap_confidence <- boot.ppfst(dat = north.south_HF_LD, nboot = 1000, diploid = TRUE)
north.south_LD_prune_bootstrap_confidence$ll
north.south_LD_prune_bootstrap_confidence$ul



# Looking at a PCA for fun
hf_pca <- indpca(site_HF_LD, ind.labels = as.vector(rownames(site_HF_LD)))
plot(hf_pca, eigen = TRUE)

# Redoing these analyses, pairwise by site and between the Adgenet populations, but breaking down the data set by year instead to see if Fst is consistent in 2017 and 2018
# Creating an overall data set with year info in the first column
year_data <- LD_prune_wall
year_data[year_data==0] <- 11
year_data[year_data==1] <- 12
year_data[year_data==2] <- 22
year_data <- as.data.frame(cbind(adgenet_assignments$Year, year_data))

# Taking individual years from that data set
year_2017 <- subset(year_data, V1 == 2017)
year_2018 <- subset(year_data, V1 == 2018)

# Taking year metadata from the adgenet_assignments table
metadata_2017 <- subset(adgenet_assignments, Year == 2017)
metadata_2018 <- subset(adgenet_assignments, Year == 2018)

# Now taking the year data sets and first looking at pairwise Fst among the 3 sites
year_2017_site <- select(year_2017, -V1)
year_2017_site <- cbind(as.numeric(as.factor(metadata_2017$Location)), year_2017_site)
View(year_2017_site[,1:2])

# Looking at pairwise Fst with hierfstat
year_2017_site_wc_fst <- pairwise.WCfst(year_2017_site, diploid = TRUE)
year_2017_site_wc_fst


# Resorting the site info data frame to work with boot.ppfst
year_2017_site <- year_2017_site[order(year_2017_site[,1]),]
View(year_2017_site[,1:2])

# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 sites
year_2017_site_bootstrap_confidence <- boot.ppfst(dat = year_2017_site, nboot = 1000, diploid = TRUE)
year_2017_site_bootstrap_confidence$ll
year_2017_site_bootstrap_confidence$ul



# Now taking the year data sets and first looking at pairwise Fst among the 3 sites
year_2018_site <- select(year_2018, -V1)
year_2018_site <- cbind(as.numeric(as.factor(metadata_2018$Location)), year_2018_site)
View(year_2018_site[,1:2])


# Resorting the site info data frame to work with boot.ppfst
year_2018_site <- year_2018_site[order(year_2018_site[,1]),]
View(year_2018_site[,1:2])

# Looking at pairwise Fst with hierfstat
year_2018_site_wc_fst <- pairwise.WCfst(year_2018_site, diploid = TRUE)
year_2018_site_wc_fst



# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 sites
year_2018_site_bootstrap_confidence <- boot.ppfst(dat = year_2018_site, nboot = 1000, diploid = TRUE)
year_2018_site_bootstrap_confidence$ll
year_2018_site_bootstrap_confidence$ul


# Now taking the year data sets and first looking at pairwise Fst using the reassigned Adgenet populations
year_2017_adgenet <- select(year_2017, -V1)
year_2017_adgenet <- cbind(as.numeric(as.factor(metadata_2017$assigned.pop.2clusters)), year_2017_adgenet)
View(year_2017_adgenet[,1:2])

# Resorting the site info data frame to work with boot.ppfst
year_2017_adgenet <- year_2017_adgenet[order(year_2017_adgenet[,1]),]
View(year_2017_adgenet[,1:2])

# Looking at pairwise Fst with hierfstat
year_2017_adgenet_wc_fst <- pairwise.WCfst(year_2017_adgenet, diploid = TRUE)
year_2017_adgenet_wc_fst


# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 reassigned populations
year_2017_adgenet_bootstrap_confidence <- boot.ppfst(dat = year_2017_adgenet, nboot = 1000, diploid = TRUE)
year_2017_adgenet_bootstrap_confidence$ll
year_2017_adgenet_bootstrap_confidence$ul


# Now taking the year data sets and first looking at pairwise Fst using the reassigned Adgenet populations
year_2018_adgenet <- select(year_2018, -V1)
year_2018_adgenet <- cbind(as.numeric(as.factor(metadata_2018$assigned.pop.2clusters)), year_2018_adgenet)
View(year_2018_adgenet[,1:2])

# Resorting the site info data frame to work with boot.ppfst
year_2018_adgenet <- year_2018_adgenet[order(year_2018_adgenet[,1]),]
View(year_2018_adgenet[,1:2])

# Looking at pairwise Fst with hierfstat
year_2018_adgenet_wc_fst <- pairwise.WCfst(year_2018_adgenet, diploid = TRUE)
year_2018_adgenet_wc_fst


# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 reassigned populations
year_2018_adgenet_bootstrap_confidence <- boot.ppfst(dat = year_2018_adgenet, nboot = 1000, diploid = TRUE)
year_2018_adgenet_bootstrap_confidence$ll
year_2018_adgenet_bootstrap_confidence$ul



# Now taking the year data sets and first looking at pairwise Fst using the North versus South populations
year_2017_north.south <- select(year_2017, -V1)
year_2017_north.south <- cbind(as.numeric(as.factor(metadata_2017$North_South)), year_2017_north.south)
View(year_2017_north.south[,1:2])

# Resorting the site info data frame to work with boot.ppfst
year_2017_north.south <- year_2017_north.south[order(year_2017_north.south[,1]),]
View(year_2017_north.south[,1:2])

# Looking at pairwise Fst with hierfstat
year_2017_north.south_wc_fst <- pairwise.WCfst(year_2017_north.south, diploid = TRUE)
year_2017_north.south_wc_fst


# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 reassigned populations
year_2017_north.south_bootstrap_confidence <- boot.ppfst(dat = year_2017_north.south, nboot = 1000, diploid = TRUE)
year_2017_north.south_bootstrap_confidence$ll
year_2017_north.south_bootstrap_confidence$ul


# Now taking the year data sets and first looking at pairwise Fst using the North versus South populations
year_2018_north.south <- select(year_2018, -V1)
year_2018_north.south <- cbind(as.numeric(as.factor(metadata_2018$North_South)), year_2018_north.south)
View(year_2018_north.south[,1:2])

# Resorting the site info data frame to work with boot.ppfst
year_2018_north.south <- year_2018_north.south[order(year_2018_north.south[,1]),]
View(year_2018_north.south[,1:2])

# Looking at pairwise Fst with hierfstat
year_2018_north.south_wc_fst <- pairwise.WCfst(year_2018_north.south, diploid = TRUE)
year_2018_north.south_wc_fst


# Looking at bootstrapped confidence intervals over 1000 iterations using the 3 reassigned populations
year_2018_north.south_bootstrap_confidence <- boot.ppfst(dat = year_2018_north.south, nboot = 1000, diploid = TRUE)
year_2018_north.south_bootstrap_confidence$ll
year_2018_north.south_bootstrap_confidence$ul
