# Creating PCAs (with Adegenet) and t-SNE (with Rtsne) plots 
library(adegenet)
library(Rtsne)
library(tidyverse)
library(vcfR)
library(cowplot)

# First looking at the not-necessarily-neutral data
all_snps <- read.vcfR("Q30_biallelic_2missing.recode.vcf")

poplist.names <- c(rep(c("Red River", "Matheson", "Dauphin River"), 16))
yearlist.names <- rep(c(rep("2017", 3), rep("2018", 3)), 8)

all_snps <- vcfR2genlight(all_snps)
all_snps@pop <- as.factor(poplist.names)

# Using a genlight PCA
all_snps_pca <- glPca(all_snps)
scatter(all_snps_pca)
# Creating a fraction for variance explained by each principal component
all_snps_var_frac <- all_snps_pca$eig/sum(all_snps_pca$eig)
all_snps_var_frac

ggplot(as.data.frame(all_snps_pca$scores), aes(x=all_snps_pca$scores[,1], y=all_snps_pca$scores[,2], color = all_snps$pop)) + 
  geom_point(aes(shape = as.factor(yearlist.names))) +
  labs(x = "PC 1 (2.95% variance)", y = "PC 2 (2.72% variance)") +
  labs(color = "Site", shape = "Year Collected")

# Create a plot of the Genlight PCA results
all_snps_pca_plot <- ggplot(as.data.frame(all_snps_pca$scores), aes(x=all_snps_pca$scores[,1], y=all_snps_pca$scores[,2], shape = factor(yearlist.names), colour = factor(poplist.names))) + 
  geom_point(size = 5) + 
  labs(x = "PC 1 (2.95% variance)", y = "PC 2 (2.72% variance)") +
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
  ) +
  scale_colour_manual(values = c("#4575b4", "#fdae61", "#d73027"))

all_snps_pca_plot



# Playing with tsne

all_snps_tsne <- Rtsne(t(na.omit(t((as.matrix(all_snps))))), dims = 2, initial_dims = 100, perplexity = 15, theta = 0.5, check_duplicates = FALSE, pca = TRUE, max_iter = 5000, verbose = TRUE)

plot(all_snps_tsne$Y)

# Creating a plot of t-SNE results
all_snps_tsne_plot <- ggplot(as.data.frame(all_snps_tsne$Y), aes(x=all_snps_tsne$Y[,1], y=all_snps_tsne$Y[,2], shape = factor(yearlist.names), colour = factor(poplist.names))) + 
  geom_point(size = 5) + 
  labs(x = "Dimension 1", y = "Dimension 2") +
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
  ) +
  scale_colour_manual(values = c("#4575b4", "#fdae61", "#d73027"))

all_snps_tsne_plot


# Repeating the same process of PCA and t-SNE, but for putatively neutral SNPs
neutral_snps <- read.vcfR("LD_prune_seq_array.vcf")
neutral_snps <- vcfR2genlight(neutral_snps)

neutral_snps@pop <- factor(poplist.names)

# Using a genlight PCA
neutral_snps_pca <- glPca(neutral_snps)
scatter(neutral_snps_pca)
# Creating a fraction for variance explained by each principal component
neutral_snps_var_frac <- neutral_snps_pca$eig/sum(neutral_snps_pca$eig)
neutral_snps_var_frac


# Create a plot of the Genlight PCA results
neutral_snps_pca_plot <- ggplot(as.data.frame(neutral_snps_pca$scores), aes(x=neutral_snps_pca$scores[,1], y=neutral_snps_pca$scores[,2], shape = factor(yearlist.names), colour = factor(poplist.names))) + 
  geom_point(size = 5) + 
  labs(x = "PC 1 (3.00% variance)", y = "PC 2 (2.64% variance)") +
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
  ) +
  scale_colour_manual(values = c("#4575b4", "#fdae61", "#d73027"))

neutral_snps_pca_plot

# Playing with tsne

neutral_snps_tsne <- Rtsne(t(na.omit(t((as.matrix(neutral_snps))))), dims = 2, initial_dims = 100, perplexity = 15, theta = 0.5, check_duplicates = FALSE, pca = TRUE, max_iter = 5000, verbose = TRUE)

plot(neutral_snps_tsne$Y)


# Creating a plot of t-SNE results
neutral_snps_tsne_plot <- ggplot(as.data.frame(neutral_snps_tsne$Y), aes(x=neutral_snps_tsne$Y[,1], y=neutral_snps_tsne$Y[,2], shape = factor(yearlist.names), colour = factor(poplist.names))) + 
  geom_point(size = 5) + 
  labs(x = "Dimension 1", y = "Dimension 2") +
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
  ) +
  scale_colour_manual(values = c("#4575b4", "#fdae61", "#d73027"))

neutral_snps_tsne_plot

# Using cowplot to plot all of these together, following the vignette here: https://cran.r-project.org/web/packages/cowplot/vignettes/shared_legends.html
arranged_plots <- plot_grid(neutral_snps_pca_plot + theme(legend.position="none"), 
  neutral_snps_tsne_plot + theme(legend.position="none"),
  all_snps_pca_plot + theme(legend.position="none"),
  all_snps_tsne_plot + theme(legend.position="none"),
  labels = "AUTO",
  label_size = 16
)
arranged_plots
# Get the legend
plot_legend <- get_legend(neutral_snps_pca_plot)

# Adding the legend to the plot
legend_with_plots <- plot_grid(arranged_plots, plot_legend, rel_widths = c(2, .5, .46))
legend_with_plots

# Saving this plot at 2000 DPI
ggsave(filename = "PCA_tsne_plots.pdf", plot = legend_with_plots, device = "pdf", dpi = 2000)
