# This script uses SNPRelate to both prune SNPs for LD and to check for relatedness using the Method of Moments

# Attempting to LD prune SNP's
if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
BiocManager::install("SNPRelate")
BiocManager::install("gdsfmt")
BiocManager::install("SeqArray")

library(gdsfmt)
library(SNPRelate)

vcf.fn <- "D:/Dropbox/Walleye_RNAseq/SNPs/rmaverick/HWE_biallelic_snps_noNA_maf0.05.recode.vcf"
snpgdsVCF2GDS(vcf.fn, "wall.gds", method="biallelic.only")

snpgdsSummary("wall.gds")
snpgdsClose("wall.gds")

genofile <- SNPRelate::snpgdsOpen("wall.gds")

# LD Pruning
set.seed(1000)
snpset <- snpgdsLDpruning(genofile, autosome.only = FALSE, ld.threshold = 0.2)

snpset.id <- unlist(snpset)
# Write out the list of SNPs found to be out of LD
write_csv(as.data.frame(snpset.id), "LD_snp_list.csv")

snpgdsCreateGenoSet("wall.gds", "LD_prune.gds", snp.id = snpset.id, verbose = TRUE)
snpgdsClose(genofile)

genofile <- SNPRelate::snpgdsOpen("LD_prune.gds")

# Getting a list of the walleye in the SNP relate dataset
sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))

# Using the LD-pruned SNPs for kinship analysis using the method of moments (MoM)
# Based on the guide provided in the vignette here: https://bioconductor.org/packages/release/bioc/vignettes/SNPRelate/inst/doc/SNPRelateTutorial.html#estimating-ibd-using-plink-method-of-moments-mom
ibd <- snpgdsIBDMoM(genofile, sample.id=NULL, snp.id=NULL,
                    maf=0.05, missing.rate=0.05, num.thread=2, autosome.only = FALSE)
# Make a data.frame
ibd.coeff <- snpgdsIBDSelection(ibd)
head(ibd.coeff)

plot(ibd.coeff$k0, ibd.coeff$k1, xlim=c(0,1), ylim=c(0,1),
     xlab="k0", ylab="k1", main="YRI samples (MoM)")
lines(c(0,1), c(1,0), col="red", lty=2)

pca <- snpgdsPCA(genofile, num.thread=2, autosome.only = FALSE)
pc.percent <- pca$varprop*100
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)
plot(tab$EV2, tab$EV1, xlab="eigenvector 2", ylab="eigenvector 1")

snpgdsOption(genofile, autosome.start = 1, autosome.end = 52,372)
snpgdsSummary(genofile)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("GWASTools", version = "3.8")
library(GWASTools)

# Use GWAS tools to convert the LD pruned .gds file from SNPrelate into a vcf. Did not work!
#genotypes <- GdsGenotypeReader("LD_prune.gds")
#genotypes <- GenotypeData(genotypes)
#vcfWrite(genotypes, vcf.file = "LD_prune_HWE_gwastools.vcf", sample.col = "sample.id", id.col = "snp.rs.id")
#vcfCheck(genotypes, "LD_prune_HWE_gwastools.vcf")


# Trying seq array, converting the SNP GDS to a seq array object, then to a VCF. Worked!
library(SeqArray)
seqSNP2GDS("LD_prune.gds", "seq_array_wall.gds")
seqSummary("seq_array_wall.gds")
seqGDS2VCF("seq_array_wall.gds", "LD_prune_seq_array.vcf")
unlink("seq_array_wall.gds", force=TRUE)


# Write the ped file with the pruned SNPs. Not super good, works but difficult to work with the map file in PGD spider.
snpgdsGDS2PED(genofile, ped.fn = "HWE_LD_wall")

snpgdsClose(genofile)

# Rewriting the map file because it has one extra column and misses chomosome information for PGD spider. Calling all snp's as belonging to chromosome "1" since these are really all genes
map_file <- read_tsv("HWE_LD_wall.map", col_names = FALSE)
map_file <- map_file %>% 
  select(-X2)
map_file <- map_file %>% 
  add_column(chromosome = c(rep("1", nrow(map_file))), .before = 1)

write_tsv(map_file, "LD_prune_snps_reformat.map", col_names = FALSE)

ped_file <- read_tsv("HWE_LD_wall.ped", col_names = FALSE)

# Following this, the map and ped files are used in PGD Spider for conversion to a VCF 