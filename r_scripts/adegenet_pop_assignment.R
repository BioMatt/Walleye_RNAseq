# Using Adegenet to look at population assignment and structure with the LD-pruned SNPs

library(tidyverse)
library(adegenet)
library(vcfR)

# Reading the LD-pruned HWE vcf
vcfR_LD_prune <- read.vcfR("LD_prune_seq_array.vcf")

genlight_LD_prune <- vcfR2genlight(vcfR_LD_prune)
rm(vcfR_LD_prune)

# Following the DAPC tutorial found here: http://adegenet.r-forge.r-project.org/files/tutorial-dapc.pdf

# Using dapc with site information to look at population separation, as opposed to clusters using find.clusters
# Taking a first look in interactive mode
site_dapc <- dapc(genlight_LD_prune, as.factor(c(rep(c("Red River", "Matheson", "Dauphin River"), 16))))
scatter(site_dapc,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("Red River", "Matheson", "Dauphin River"), col=c("red","blue", "green"))


site_dapc$posterior
summary(site_dapc)

# Using a.score and optim.a.score to find the optimal number of principal components to retain in the final site DAPC
site_a_score <- a.score(site_dapc)
site_optim_a <- optim.a.score(site_dapc)


# Resorting individuals for the dapc so compoplot looks better
resorted_matrix <- as.matrix(genlight_LD_prune)
resorted_matrix <- cbind(rownames(resorted_matrix), resorted_matrix)
resorted_matrix <- resorted_matrix[order(resorted_matrix[,1]),]
resorted_matrix <- resorted_matrix[,-1]

# Making a new genlight object with the resorted walleye
genlight_LD_prune <- new("genlight", gen = resorted_matrix, ploidy = 2, ind.names = rownames(resorted_matrix), loc.names = colnames(resorted_matrix), pop = as.factor(c(rep("Red River", 8), rep("Matheson", 8), rep("Dauphin River", 8), rep("Red River", 8), rep("Matheson", 8), rep("Dauphin River", 8))))

# Using 7 principal components and 2 discriminant axes retained in the discriminant analysis step
optim_site_dapc <- dapc(genlight_LD_prune, n.pca = 7, n.da = 2)


scatter(optim_site_dapc,scree.da=FALSE, bg="white", posi.pca="bottomleft", legend=FALSE,
        txt.leg=c("Red River", "Matheson", "Dauphin River"), col=c("#4575b4", "#fdae61", "#d73027"), mstree = FALSE, solid = 1)
# Using compoplot to look at a Structure-like 
compoplot(optim_site_dapc, legend = FALSE, show.lab = FALSE, col = c("#4575b4", "#fdae61", "#d73027"))


compoplot(optim_site_dapc, posi=list(x=0,y=-.09), show.lab = FALSE, col.pal = spectral)
assignplot(optim_site_dapc, subset = 1:48)

# Look at admixed individuals, arbitrarily defined as having no more than 0.5 probability of membership to any groups
site_admixed <- which(apply(optim_site_dapc$posterior,1, function(e) all(e<0.5)))
site_admixed

#######################################################################################
# Using find.clusters to try and find the "true" number of groups in the data 
# Taking all the clusters, 2 probably represents the data most accurately with the lowest BIC using max.n.clust 40 and 40 PC's retained at first
clusters <- find.clusters(genlight_LD_prune, max.n.clust = 40)
clusters$grp
clusters$size

clusters3 <- find.clusters(genlight_LD_prune, max.n.clust = 40)
clusters3$grp
clusters3$size

# Using cross validation with the 2 cluster assignments
xval_2clust <- xvalDapc(as.matrix(genlight_LD_prune), clusters$grp, n.pca.max = 300, training.set = 0.9,
                        result = "groupMean", center = TRUE, scale = FALSE,
                        n.pca = NULL, n.rep = 100, xval.plot = TRUE)
xval_2clust[2:6]


# Running a DAPC in interactive mode to look at the data
dapc <- dapc(genlight_LD_prune, clusters$grp)
scatter(dapc,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("South", "North"), col=c("red","blue"))
dapc$posterior
summary(dapc)

# Taking a look at the population assignment plot
assignplot(dapc, subset = 1:48)

# Taking a look at the same plot, but in a Structure-like format
compoplot(dapc, posi = "bottomright", txt.leg = paste("Cluster", 1:2), lab = "", ncol = 1, xlab = "Individuals")

# Using the a-score to look at discrimination versus over-fitting, using many PCs here
dapc2 <- dapc(genlight_LD_prune, clusters$grp, n.da = 100, n.pca = 45)
scatter(dapc2,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("South", "North"), col=c("red","blue"))
compoplot(dapc2, lab="", posi=list(x=12,y=-.01), cleg=.7)
a_score <- a.score(dapc2)
optim_a <- optim.a.score(dapc2)

# Using an a score of 5 because that was the one with the highest a score
dapc3 <- dapc(genlight_LD_prune, clusters$grp, n.da = 100, n.pca = 5)


scatter(dapc3,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("Cluster 1", "Cluster 2"), col=c("#4575b4","#d73027"), cex.lab = 10)


compoplot(dapc3, posi=list(x=12,y=.1), cleg=.7, show.lab = TRUE)


# Using find.clusters with 5 PCs retained, as suggested by optim.a.score previously
clusters2 <- find.clusters(genlight_LD_prune)
# Here, we chose 5 PCs with 2 clusters to keep
# Using the a-score to look at discrimination versus over-fitting
dapc4 <- dapc(genlight_LD_prune, clusters2$grp, n.da = 100, n.pca = 45)
scatter(dapc4,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=paste("Cluster", 1:3), col=c("red","blue", "green"))
compoplot(dapc4, posi = "bottomright", txt.leg = paste("Cluster", 1:3), lab = "", ncol = 1, xlab = "Individuals")
a_score2 <- a.score(dapc4)
optim_a2 <- optim.a.score(dapc4)


# Finally, using the 3 clusters with 5 PCs to look at a DAPC
dapc5 <- dapc(genlight_LD_prune, clusters2$grp, n.da = 100, n.pca = 5)
scatter(dapc5,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=paste("Cluster", 1:3), col=c("red","blue", "green"))
# Taking a look at the population assignment plot
assignplot(dapc5, subset = 1:48)
compoplot(dapc5, posi=list(x=12,y=.1), cleg=.7, show.lab = TRUE)

# Using cross validation with the 3 clusters to look at accuracy using 5 PCs
xval_3clust <- xvalDapc(as.matrix(genlight_LD_prune), clusters2$grp, n.pca.max = 300, training.set = 0.9,
                 result = "groupMean", center = TRUE, scale = FALSE,
                 n.pca = NULL, n.rep = 30, xval.plot = TRUE)
xval_3clust[2:6]


# Take the assignments from the DAPC and comparing them to site collected
pop.assignments <- as.matrix(dapc5$grp)
pop.assignments <- as_tibble(pop.assignments, .name_repair = make.names, rownames = NA)
colnames(pop.assignments) <- "assigned.pop.3clusters"
pop.assignments <- rownames_to_column(pop.assignments, var = "Sample_ID")

# Read in the sequencing metadata
sequenced_wall <- read_delim("sequenced_walleye.txt", col_names = TRUE, delim = "\t")

# Join the sequenced data table with the new population assignments
sequenced_wall <- full_join(sequenced_wall, pop.assignments, by = c("Sample_ID" = "Sample_ID"))

# Take the assignments from the DAPC and comparing them to site collected, but from the 2 cluster DAPC instead
pop.assignments2 <- as.matrix(dapc3$grp)
pop.assignments2 <- as_tibble(pop.assignments2, .name_repair = make.names, rownames = NA)
colnames(pop.assignments2) <- "assigned.pop.2clusters"
pop.assignments2 <- rownames_to_column(pop.assignments2, var = "Sample_ID")


# Join the sequenced data table with the new population assignments from 2 clusters
sequenced_wall <- full_join(sequenced_wall, pop.assignments2, by = c("Sample_ID" = "Sample_ID"))

# Writing the adegenet assigned populations to a table, for double checking with hierfstat
write_delim(sequenced_wall, "adegenet_pop_assignments.txt", delim = "\t")

########################################################################################################################################################
# Using North (Dauphin River) versus South (Red River + Matheson) population assignments, instead
sequenced_wall$North_South <- c(rep("South", 16), rep("North", 8), rep("South", 16), rep("North", 8))

# Running DAPC in exploratory mode at first, using 45 PCs and 1 discriminant function retained
north.south_dapc <- dapc(genlight_LD_prune, as.factor(c(rep(c("South", "South", "North"), 16))))
scatter(north.south_dapc,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("South", "North"), col=c("red","blue"))

# Estimaing optimum a scores for a North-South split
north.south_a_score <- a.score(north.south_dapc)
north.south_optim_a <- optim.a.score(north.south_dapc)
# 1 PC retained is optimal according to optim.a.score
north.south_optim_dapc <- dapc(genlight_LD_prune, as.factor(c(rep(c("South", "South", "North"), 16))), n.da = 100, n.pca = 1)
scatter(north.south_optim_dapc,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("South", "North"), col=c("red","blue"))


##################
# Trying again with the North-South split, but instead putting the Matheson fish into the "North" group 
# Running DAPC in exploratory mode at first, using 45 PCs and 1 discriminant function retained
other_north.south_dapc <- dapc(genlight_LD_prune, as.factor(c(rep(c("South", "North", "North"), 16))))
scatter(other_north.south_dapc,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("South", "North"), col=c("red","blue"))

# Estimaing optimum a scores for a North-South split
other_north.south_a_score <- a.score(other_north.south_dapc)
other_north.south_optim_a <- optim.a.score(other_north.south_dapc)
# 1 PC retained is optimal according to optim.a.score
other_north.south_optim_dapc <- dapc(genlight_LD_prune, as.factor(c(rep(c("South", "North", "North"), 16))), n.da = 100, n.pca = 1)
scatter(other_north.south_optim_dapc,scree.da=TRUE, bg="white", posi.pca="bottomleft", legend=TRUE,
        txt.leg=c("South", "North"), col=c("red","blue"))
