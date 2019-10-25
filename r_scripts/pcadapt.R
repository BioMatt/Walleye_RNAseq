# A script to use pcadapt to explore possible local adaptation in Lake Winnipeg walleye using SNPs from RNA.

library(vcfR)
library(tidyverse)
library(pcadapt)
library(enrichR)


setwd("D:/Walleye_RNAseq/local_adaptation")
setwd("E:/Walleye_RNAseq/local_adaptation")

vcfR_wall <- read.vcfR("Q30_biallelic_2missing.recode.vcf")
vcfR_wall <- addID(vcfR_wall, sep = "_")
genlight_wall <- vcfR2genlight(vcfR_wall)
#tidy_wall <- vcfR2tidy(vcfR_wall)
genlight_wall@pop <- as.factor(c(rep(c("R", "M", "D"), 16)))

dapc <- dapc(genlight_wall)
scatter(dapc,scree.da=TRUE, bg="white", posi.pca="topright", legend=TRUE,
        txt.leg=c("D", "M", "R"), col=c("red","blue", "green"))


wall_tibble <- as_tibble(markdup_wall@gt)
wall_tibble <- add_column(wall_tibble, SNP_ID = markdup_wall@fix[,3])
wall_tibble <- column_to_rownames(wall_tibble, var = "SNP_ID")
wall_tibble <- base::subset(wall_tibble, select = -FORMAT)

for (i in 1:nrow(wall_tibble)){
  for (j in 1:ncol(wall_tibble)){
    wall_tibble[i,j] <- substr(wall_tibble[i,j], 0, 3)
  }
}

test_tibble <- wall_tibble

# converting that genotype from 0/0 VCF format to 0/1/2 genlight format  
for (i in 1:nrow(wall_tibble))
{
  for (j in 1:ncol(wall_tibble))
  {
    if (wall_tibble[i,j] == "0/0"){
      wall_tibble[i,j] <- "0"
    } else if (wall_tibble[i,j] == "0/1"){
      wall_tibble[i,j] <- "1"
    } else if (wall_tibble[i,j] == "1/1"){
      wall_tibble[i,j] <- "2"
    } else {
      wall_tibble[i,j] <- NA
    }
  }
} 

#wall_tibble <- na.omit(wall_tibble)

#individuals2strata(as.data.frame(genlight_wall@ind.names))

converted_data <- genomic_converter(genlight_wall, output = c("genlight", "pcadapt", "bayescan"), imputation.method = NULL, monomorphic.out = TRUE, strata = "strata.tsv")


# Following the PCAdapt vignette: https://cran.r-project.org/web/packages/pcadapt/vignettes/pcadapt.html
# Load in the VCF
pcadapt_data <- read.pcadapt("Q30_biallelic_2missing.recode.vcf", type = "vcf")

# Do some exploratory plots using K = 20 to get at 'all' the variation present
x.1 <- pcadapt(input = pcadapt_data, K = 20) 
plot(x.1, option = "screeplot")

poplist.names <- c(rep(c("Red River", "Matheson", "Dauphin River"), 16))

plot.pcadapt(x.1, option = "scores", pop = poplist.names)

plot(x.1, option = "scores", i = 3, j = 4, pop = poplist.names)

# Keeping K = 2, following Cattell's rule for the points to the left of the straight line
x <- pcadapt(input = pcadapt_data, K = 2) 
plot(x, option = "scores", pop = poplist.names)


summary(x)
plot(x , option = "manhattan")

plot(x, option = "qqplot")
hist(x$pvalues, xlab = "p-values", main = NULL, breaks = 50, col = "orange")
plot(x, option = "stat.distribution")

# Plotting by year rather than site
yearlist.names <- rep(c(rep("2017", 3), rep("2018", 3)), 8)
plot(x, option = "scores", pop = yearlist.names)
x$singular.values

# Create a plot of the PCDapt PCA results
pcadapt_plot <- ggplot(as.data.frame(x$scores), aes(x=x$scores[,1], y=x$scores[,2], shape = factor(yearlist.names), colour = factor(poplist.names))) + 
  geom_point(size = 5) + 
  labs(x = "PC1 (16.7% variance)", y = "PC2 (16.1% variance)") +
  labs(color = "Site", shape = "Year Collected") +
  theme_bw() +
  theme(panel.border = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        text=element_text(size=16,  family="serif")
  )

# Customize the colors on the PCA
pcadapt_plot + scale_colour_manual(values = c("Black", "Orange", "Brown"))
pcadapt_plot + scale_colour_manual(values = c("#4575b4", "#fdae61", "#d73027"))
pcadapt_plot + scale_colour_brewer(palette = "Set1")

# Save the plot with the colors I want, with a high DPI for publication
ggsave(filename = "PCAdapt_plot.pdf", plot = pcadapt_plot + scale_colour_manual(values = c("#4575b4", "#fdae61", "#d73027")), device = "pdf", dpi = 2000)

# Getting significant outlier SNPs using PCadapt and qvalue
library(qvalue)

qval <- qvalue(x$pvalues)$qvalues
alpha <- 0.05
outliers <- which(qval < alpha)
length(outliers)

# Relating outliers with principle components to get evolutionary pressure
snp_pc <- get.pc(x, outliers)
snp_pc_outliers <- get.pc(x, outliers)
# Getting quick counts of how many outliers belong in PC1 and PC2
nrow(subset(snp_pc_outliers))
nrow(subset(snp_pc_outliers, PC == "1"))
nrow(subset(snp_pc_outliers, PC == "2"))


# Adding in locus names to the outlier SNPs and principle components
outlier.snp.names <- matrix(nrow = nrow(snp_pc), ncol = 1, dimnames = list(c(), c("SNP_ID")))
# Pulling the SNP ID's from the genlight object based on which SNP they are in PC Adapt
for (i in 1:nrow(snp_pc)){
  outlier.snp.names[i] <- genlight_wall$loc.names[snp_pc$SNP[i]]
} 

snp_pc <- cbind(outlier.snp.names, snp_pc)
rm(outlier.snp.names)

# Add in q values
snp_pc <- cbind(snp_pc, q.value = qval[outliers])
# Split the SNP ID's to get cluster ID's, for relating to gene annotations
snp_pc <- snp_pc %>% 
  tidyr::separate(SNP_ID, into = c("Cluster", "Position"), sep = "_", remove = FALSE)




# Add in transcript information from the corset clusters table
snp_pc <- left_join(snp_pc, corset_clusters, by = c("Cluster" = "X2"))

# Add in annotations from the filtered annotation report
snp_pc <- left_join(snp_pc, ann_report_filtered, by = c("X1" = "transcript_id"))

# Write a table of outlier SNPs
write_tsv(snp_pc, "PCAdapt_outlier_SNPs.txt")


# Taking only PC 1 from the larger table
snp_pc.1 <- subset(snp_pc, PC == "1")




# Converting from Corset clusters to transcript ID's added in duplicate SNPs, so now filter for unique ones
snp_pc.1 <- dplyr::distinct(snp_pc.1, gene.name, .keep_all = TRUE)

# Taking only PC 2 from the larger table
snp_pc.2 <- subset(snp_pc, PC == "2")



# Converting from Corset clusters to transcript ID's added in duplicate SNPs, so now filter for unique ones
snp_pc.2 <- dplyr::distinct(snp_pc.2, gene.name, .keep_all = TRUE)

# Writing PC1 and PC2 gene lists for analysis by enrichR online.
write.table(snp_pc.1$gene.name, file = "PC1_gene_names_q0.05.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(snp_pc.2$gene.name, file = "PC2_gene_names_q0.05.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Looking at GO terms enriched in this list of genes
snp_pc.1_enriched <- enrichr(c(snp_pc.1$gene.name), "GO_Biological_Process_2018")

# Taking the z scores from the PC Adapt data to get positive and negative values for each SNP
z_scores_pc1 <- matrix(nrow = nrow(snp_pc.1), ncol = 1, dimnames = list(c(), c("Z_score")))
for (i in 1:nrow(snp_pc.1)){
  z_scores_pc1[i] <- x$zscores[snp_pc.1$SNP[i]]
} 

# Combining z score info with gene annotation info
snp_pc.1 <- cbind(snp_pc.1, z_scores_pc1)

# Writing csv's with positive and negative z scores
snp_pc.1_positive.Zscore <- subset(snp_pc.1, Z_score > 0)
write.csv(snp_pc.1_positive.Zscore$gene.name, "PC1_positive_Zscore_gene_names.csv", row.names = FALSE, quote = FALSE)

snp_pc.1_negative.Zscore <- subset(snp_pc.1, Z_score < 0)
write.csv(snp_pc.1_negative.Zscore$gene.name, "PC1_negative_Zscore_gene_names.csv", row.names = FALSE, quote = FALSE)

# Plotting the loadings on PC1
plot(x$loadings[, 1], pch = 19, cex = .3, ylab = paste0("Loadings PC", 1))

# Trying the Benjamini-Hochberg Procedure for P values
padj <- p.adjust(x$pvalues, method= "BH")
alpha <- 0.05
outliers <- which(qval < alpha)
length(outliers)
