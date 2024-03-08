# Identity rules task

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
setwd("./test/identity_rules/batchconv32/ESBN_contextnorm_lr0.0005")


# Create a vector, and load data from the folder which 
# are in separate .txt files (run1.txt, run2.txt, ...)
identity_batchconv32 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchconv32 <- c(identity_batchconv32, run_i$acc)
}

# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchconv16/ESBN_contextnorm_lr0.0005")


identity_batchconv16 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchconv16 <- c(identity_batchconv16, run_i$acc)
}

# 8 batch size 
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchconv8/ESBN_contextnorm_lr0.0005")


identity_batchconv8 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchconv8 <- c(identity_batchconv8, run_i$acc)
}

# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchconv4/ESBN_contextnorm_lr0.0005")

identity_batchconv4 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchconv4 <- c(identity_batchconv4, run_i$acc)
}

# RANDOM ENCODER - Loading of data
#-------------------------------------------

# 32 batch size
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchrand32/ESBN_contextnorm_lr0.0005")

identity_batchrand32 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchrand32 <- c(identity_batchrand32, run_i$acc)
}

# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchrand16/ESBN_contextnorm_lr0.0005")

identity_batchrand16 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchrand16 <- c(identity_batchrand16, run_i$acc)
}

# 8 batch size
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchrand8/ESBN_contextnorm_lr0.0005")

identity_batchrand8 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchrand8 <- c(identity_batchrand8, run_i$acc)
}

# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))
setwd("./test/identity_rules/batchrand4/ESBN_contextnorm_lr0.0005")

identity_batchrand4 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  identity_batchrand4 <- c(identity_batchrand4, run_i$acc)
}

#---------------------------------------
# Analysis of data

# Put all the data in the same dataframe. 
# Acc = test accuracy of that run, 
# batch_size = which batch size condition is the data from (32, 16, 18, 4)
# encoder = which encoder condition is the data from (conv, rand)
setwd(dirname(getActiveDocumentContext()$path))
df_identity <- data.frame(acc = c(identity_batchconv32,
                         identity_batchconv16,
                         identity_batchconv8,
                         identity_batchconv4,
                         identity_batchrand32,
                         identity_batchrand16,
                         identity_batchrand8,
                         identity_batchrand4),
                 batch_size = as.factor(rep(c(32,16,8,4), each = 10)),
                 encoder = as.factor(rep(c("conv","rand"), each = 40)))



df_identity <- cbind(df_identity, rank_acc = rank(df_identity$acc))

# Show the number of data points in each condition pair 
table(df_identity$batch_size, df_identity$encoder)

df_identity %>% 
  group_by(encoder, batch_size) %>%
  summarize(mean_acc = mean(acc), sd_acc = sd(acc))

df_identity %>% 
  group_by(encoder) %>%
  summarize(mean_acc = mean(acc), sd_acc = sd(acc))

df_identity %>% 
  group_by(batch_size) %>%
  summarize(mean_acc = mean(acc), sd_acc = sd(acc))

# Visualize the data trend, along with their standard error and means 
p_identity <- ggline(
       df_identity, 
       title = "Identity-rules: Plot of test accuracy M and CI by encoder and batch size conditions",
       xlab = "Batch size",
       ylab = "Accuracy",
       x = "batch_size", 
       y = "acc", 
       color = "encoder",
       add = c("mean_se"),
       palette = c("#00AFBB", "#E7B800")
       ) 


p_identity

# Visualize the data trend, along with their standard error and means 
p_identity_2 <- ggline(
  df_identity, 
  title = "Identity-rules: Plot of test accuracy rank M and CI by encoder and batch size conditions",
  xlab = "Batch size",
  ylab = "Rank(Accuracy)",
  x = "batch_size", 
  y = "rank_acc", 
  color = "encoder",
  add = c("mean_se"),
  palette = c("#00AFBB", "#E7B800")
) 


p_identity_2



# Two Way Anova
two_way_anova_identity <- aov(acc ~ batch_size * encoder,
                          data = df_identity)


# Summary of results
two_way_anova_identity
summary(two_way_anova_identity)

qqnorm(
  two_way_anova_identity$resid, pch = 20, 
  main = "Q-Q plot for the Two-Way ANOVA performed on untransformed data",
  cex.lab = 1, cex.axis = 0.7, cex.main = 1
)
qqline(two_way_anova_identity$resid)



# Assumption check for ANOVA 
# Equality of variances
leveneTestIdentity <- leveneTest(two_way_anova_identity_real_2)
leveneTestIdentity$`Pr(>F)`[1]
leveneTestIdentity

# Normality of data
aov_residuals <- residuals(two_way_anova_identity_real_2)
shapiro.test(x = aov_residuals )

# Normality of residuals 
par(mfrow=c(2,1))
plot(two_way_anova_identity_real_2)
par(mfrow=c(1,1))



# # Two Way Anova
# two_way_anova_identity_pre <- aov(rank(acc) ~ batch_size * encoder,
#                               data = df_identity,
#                               contrasts = list (
#                                 batch_size = "contr.sum",
#                                 encoder    = "contr.sum"
#                               )
#                             )
# 
# summary(two_way_anova_identity_pre)
# 
# two_way_anova_identity <- Anova(two_way_anova_identity_pre, type = 'III')
# two_way_anova_identity

# # Assumption check for ANOVA
# # Equality of variances
# leveneTestIdentity <- leveneTest(acc ~ batch_size * encoder, data = df_identity)
# leveneTestIdentity$`Pr(>F)`[1]
# 
# 
# # Normality of residuals 
# par(mfrow=c(2,2))
# plot(two_way_anova_identity_pre)
# par(mfrow=c(1,1))
# 
# 
# 
# 
# # Normality of data
# aov_residuals <- residuals(object = two_way_anova_identity_pre)
# shapiro.test(x = aov_residuals )
# 
# # Summary of results
# 
model.tables(two_way_anova_identity, type="means", se = TRUE)


# Post hoc analysis


# First, estimate marginal means. Second, generate contrasts
# Third, perform the post-hoc tests Bonferroni corrected.

# Marginal means
estimated_marginal_means_identity <- emmeans(two_way_anova_identity, c("batch_size","encoder"))


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


contrasts_identity <- list (
  conv_batch_size32_16   = c(0,0,-1,1,0,0,0,0),
  conv_batch_size32_4    = c(-1,0,0,1,0,0,0,0),
  rand_batch_size32_16   = c(0,0,0,0,0,0,-1,1),
  rand_batch_size32_4    = c(0,0,0,0,-1,0,0,1),
  batch_size32_conv_rand = c(0,0,0,-1,0,0,0,1),
  batch_size4_conv_rand  = c(-1,0,0,0,1,0,0,0)
)

posthoc_identity <- contrast(estimated_marginal_means_identity, contrasts_identity, adjust = "bonf")

posthoc_identity

table_identity <- apa.aov.table(two_way_anova_identity, table.number = 2)
apa.save("table_identity_new.doc", table_identity)



# plot3 <- ggplot(df_dist3, aes(x = rank(acc))) +
#   geom_histogram(aes(color = encoder, fill = encoder),
#                  alpha = 0.5, position = "identity") +
#   facet_grid(cols = vars(batch_size)) +
#   theme_minimal() +
#   labs(title = "Histogram of task accuracy ranks grouped by encoder and batch size") +
#   scale_y_continuous("Count", breaks = c(1:10)) +
#   scale_x_continuous("Rank (Accuracy)") +
#   scale_color_manual(values = c("#00AFBB", "#E7B800")) +
#   scale_fill_manual(values = c("#00AFBB", "#E7B800"))
# 
# plot3
