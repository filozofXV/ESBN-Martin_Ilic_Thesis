# Distribution-of-three task

# Install packages
# install.packages("ggpubr")
# install.packages("rstudioapi")
# install.packages("emmeans")
# remotes::install_github("dstanley4/apaTables")

library("apaTables")
library("rstudioapi")   
library("ggpubr")
library("car")
library("emmeans")
library("dplyr")
# CONVOLUTIONAL ENCODER - Loading of data
#------------------------------------

# 32 batch size

# These two lines of code first set the working directory 
# to this file's location, and then navigate to the specific
# directory for each condition (e.g., conv32)

setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv32/ESBN_contextnorm_lr0.0005")


# Create a vector, and load data from the folder which 
# are in separate .txt files (run1.txt, run2.txt, ...)
dist3_batchconv32 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv32 <- c(dist3_batchconv32, run_i$acc)
}

# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv16/ESBN_contextnorm_lr0.0005")

dist3_batchconv16 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv16 <- c(dist3_batchconv16, run_i$acc)
}

# 8 batch size 
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv8/ESBN_contextnorm_lr0.0005")

dist3_batchconv8 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv8 <- c(dist3_batchconv8, run_i$acc)
}

# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv4/ESBN_contextnorm_lr0.0005")

dist3_batchconv4 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv4 <- c(dist3_batchconv4, run_i$acc)
}

# RANDOM ENCONDER - Loading of data
#------------------------------------
# 32 batch size

setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand32/ESBN_contextnorm_lr0.0005")

dist3_batchrand32 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand32 <- c(dist3_batchrand32, run_i$acc)
}

# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand16/ESBN_contextnorm_lr0.0005")

dist3_batchrand16 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand16 <- c(dist3_batchrand16, run_i$acc)
}

# 8 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand8/ESBN_contextnorm_lr0.0005")

dist3_batchrand8 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand8 <- c(dist3_batchrand8, run_i$acc)
}

# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand4/ESBN_contextnorm_lr0.0005")

dist3_batchrand4 <- c()

run_r <- read.delim("run1.txt", header = T, sep = " ")
strsplit(run_r$association, ",")

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand4 <- c(dist3_batchrand4, run_i$acc)
}

setwd(dirname(getActiveDocumentContext()$path))  

#---------------------------------------
# Analysis of data

# Put all the data in the same dataframe. 
# Acc = test accuracy of that run, 
# batch_size = which batch size condition is the data from (32, 16, 18, 4)
# encoder = which encoder condition is the data from (conv, rand)

df_dist3 <- data.frame(acc = c(dist3_batchconv32,
                                  dist3_batchconv16,
                                  dist3_batchconv8,
                                  dist3_batchconv4,
                                  dist3_batchrand32,
                                  dist3_batchrand16,
                                  dist3_batchrand8,
                                  dist3_batchrand4),
                          batch_size = as.factor(rep(c(32,16,8,4), each = 10)),
                          encoder = as.factor(rep(c("conv","rand"), each = 40)))

df_dist3 <- cbind(df_dist3, 
                  rank_acc = rank(df_dist3$acc, 
                                  ties.method = "average"))


# Show the number of data points in each condition pair 
table(df_dist3$batch_size, df_dist3$encoder)

# Visualize the data trend, along with their standard error and means 
df_dist3 %>% 
  group_by(encoder, batch_size) %>%
  summarize(mean_acc = mean(acc), sd_acc = sd(acc))

df_dist3 %>% 
  group_by(encoder) %>%
  summarize(mean_acc = mean(acc), sd_acc = sd(acc))

df_dist3 %>% 
  group_by(batch_size) %>%
  summarize(mean_acc = mean(acc), sd_acc = sd(acc))

# Visualize the data trend, along with their standard error and means 
p_dist3 <- ggline(
  df_dist3, 
  title = "Distribution-of-three: Plot of test accuracy M and CI by encoder and batch size conditions",
  xlab = "Batch size",
  ylab = "Accuracy",
  x = "batch_size", 
  y = "acc", 
  color = "encoder",
  add = c("mean_se"),
  palette = c("#00AFBB", "#E7B800")
) 


p_dist3

# Two Way Anova
two_way_anova_dist3<- aov(acc ~ batch_size * encoder,
                               data = df_dist3)

# Assumption check for ANOVA 
# Equality of variances
leveneTestdist3 <- leveneTest(two_way_anova_dist3)
leveneTestdist3$`Pr(>F)`[1]
leveneTestdist3

# Normality of data
aov_residuals <- residuals(two_way_anova_dist3)
shapiro.test(x = aov_residuals )

# Normality of residuals 
par(mfrow=c(2,1))
plot(two_way_anova_dist3)
par(mfrow=c(1,1))



qqnorm(
  two_way_anova_dist3$resid, pch = 20, 
  main = "Q-Q plot for the Two-Way ANOVA performed on untransformed data",
  cex.lab = 1, cex.axis = 0.7, cex.main = 1
)
qqline(two_way_anova_dist3$resid)



# # Two Way Anova
# two_way_anova_dist3 <- aov(rank(acc) ~ batch_size * encoder,
#                                   data = df_dist3,
#                                   contrasts = list (
#                                     batch_size = "contr.sum",
#                                     encoder    = "contr.sum"
#                                   )
#                                 )
# 
# two_way_anova_dist3 <- Anova(two_way_anova_dist3, type = 'III')
# two_way_anova_dist3
# 
# # Summary of results
# two_way_anova_dist3$resid

# qqnorm(
#   two_way_anova_dist3$resid, pch = 20, main = "Q-Q plot for the Two-Way ANOVA performed on rank transformed data",
#   cex.lab = 1, cex.axis = 0.7, cex.main = 1
# )
# qqline(two_way_anova_dist3$resid)
# 
# 
# plot2 <- ggplot(df_identity, aes(x = rank(acc))) +
#   geom_histogram(aes(color = encoder, fill = encoder),
#                  alpha = 0.5, position = "identity") +
#   facet_grid(cols = vars(batch_size)) +
#   theme_minimal() +
#   labs(title = "Histogram of task accuracy ranks grouped by encoder and batch size") +
#   scale_y_continuous("Frequency", breaks = c(1:10)) +
#   scale_x_continuous("Rank (Accuracy)") +
#   scale_color_manual(values = c("#00AFBB", "#E7B800")) +
#   scale_fill_manual(values = c("#00AFBB", "#E7B800"))
# 
# 
# 
# plot2

# Summary

model.tables(two_way_anova_dist3, type="means", se = TRUE)

p_dist3

# # Visualize the data trend, along with their standard error and means 
# p_dist3_2 <- ggline(
#   df_dist3, 
#   title = "Distribution-of-three: Plot of test accuracy rank M and CI by encoder and batch size conditions",
#   xlab = "Batch size",
#   ylab = "Rank(Accuracy)",
#   x = "batch_size", 
#   y = "rank_acc", 
#   color = "encoder",
#   add = c("mean_se"),
#   palette = c("#00AFBB", "#E7B800")
# ) 
# 
# 
# p_dist3_2


# Post hoc analysis


# First, estimate marginal means. Second, generate contrasts
# Third, perform the post-hoc tests Bonferroni corrected.

# Marginal means
estimated_marginal_means_dist3 <- emmeans(two_way_anova_dist3, c("batch_size","encoder"))


# Contrasts 
# Batch size  Encoder
# 4           conv
# 8           conv
# 16          conv
# 32          conv 
# 4           rand
# 8           rand
# 16          rand
# 32          rand


contrasts_dist3 <- list (
  conv_batch_size32_16   = c(0,0,-1,1,0,0,0,0),
  conv_batch_size32_4    = c(-1,0,0,1,0,0,0,0),
  rand_batch_size32_16   = c(0,0,0,0,0,0,-1,1),
  rand_batch_size32_4    = c(0,0,0,0,-1,0,0,1),
  batch_size32_conv_rand = c(0,0,0,1,0,0,0,-1),
  batch_size4_conv_rand  = c(1,0,0,0,-1,0,0,0)
)

# Perform post hoc tests
posthoc_dist3 <- contrast(estimated_marginal_means_dist3, contrasts_dist3, adjust = "bonf")

posthoc_dist3


# Produce ANOVA Tables

table_dist3 <- apa.aov.table(two_way_anova_dist3, table.number = 1)
apa.save("table_dist3_2.doc", table_dist3)
#---------------------------------------------------------------------


# CONVOLUTIONAL ENCODER - Loading of data
#------------------------------------

# 32 batch size

# These two lines of code first set the working directory 
# to this file's location, and then navigate to the specific
# directory for each condition (e.g., conv32)
par(mfrow = c(2,2))
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv32/ESBN_contextnorm_lr0.0005")


# Create a vector, and load data from the folder which 
# are in separate .txt files (run1.txt, run2.txt, ...)
dist3_assoc32 <- c()
dist3_error32 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_assoc32 <- c(dist3_assoc32, 
                     round(as.numeric(strsplit(run_i$association, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$association, ",")[[1]]))]/100, 2))
  dist3_error32 <- c(dist3_error32,
                     round(as.numeric(strsplit(run_i$error, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$error, ",")[[1]]))]/100, 2))
}

dist3_total32 <- round(dist3_assoc32*dist3_error32,2) * 100



ggplot() + aes(dist3_total32) + 
  geom_histogram() + 
  labs(title = "Histogram of association error count (out of 100 trials) in test runs (Convolutional, batch size 32)", 
       x = "Number of association errors/run of 100 trials", y = "Count")
# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv16/ESBN_contextnorm_lr0.0005")

dist3_assoc16 <- c()
dist3_error16 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_assoc16 <- c(dist3_assoc16, 
                    round(as.numeric(strsplit(run_i$association, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$association, ",")[[1]]))]/100, 2))
  dist3_error16 <- c(dist3_error16,
                    round(as.numeric(strsplit(run_i$error, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$error, ",")[[1]]))]/100, 2))
}

dist3_total16 <- round(dist3_assoc16*dist3_error16,2)*100

ggplot() + aes(dist3_total16) + 
  geom_histogram() + 
  labs(title = "Histogram of association error count (out of 100 trials) in test runs (Convolutional, batch size 16)", 
       x = "Number of association errors/run of 100 trials", y = "Count")
# 8 batch size 
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv8/ESBN_contextnorm_lr0.0005")

dist3_assoc8 <- c()
dist3_error8 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_assoc8 <- c(dist3_assoc8, 
                    round(as.numeric(strsplit(run_i$association, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$association, ",")[[1]]))]/100, 2))
  dist3_error8 <- c(dist3_error8,
                    round(as.numeric(strsplit(run_i$error, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$error, ",")[[1]]))]/100, 2))
}

dist3_total8 <- round(dist3_assoc8*dist3_error8,2)*100

ggplot() + aes(dist3_total8) + 
  geom_histogram() + 
  labs(title = "Histogram of association error count (out of 100 trials) in test runs (Convolutional, batch size 8)", 
       x = "Number of association errors/run of 100 trials", y = "Count")
# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv4/ESBN_contextnorm_lr0.0005")

dist3_assoc4 <- c()
dist3_error4 <- c()

for (i in 1:100) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_assoc4 <- c(dist3_assoc4, 
                    round(as.numeric(strsplit(run_i$association, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$association, ",")[[1]]))]/100, 2))
  dist3_error4 <- c(dist3_error4,
                    round(as.numeric(strsplit(run_i$error, ",")[[1]])[!is.na(as.numeric(strsplit(run_i$error, ",")[[1]]))]/100, 2))
}

dist3_total4 <- round(dist3_assoc4*dist3_error4, 2)*100

ggplot() + aes(dist3_total4) + 
  geom_histogram() + 
  labs(title = "Histogram of association error count (out of 100 trials) in test runs (Convolutional, batch size 4)", 
       x = "Number of association errors/run of 100 trials", y = "Count")


