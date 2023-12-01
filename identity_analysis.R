# Identity rules task

# Install packages
install.packages("ggpubr")
install.packages("rstudioapi")
install.packages("emmeans")

library("rstudioapi")   
library("ggpubr")
library("car")
library("emmeans")

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

# Show the number of data points in each condition pair 
table(df_identity$batch_size, df_identity$encoder)

# Visualize the data trend, along with their standard error and means 
p <- ggline(df_identity, 
       title = "Plot of test accuracy by encoder and batch size conditions",
       xlab = "Batch size",
       ylab = "Accuracy",
       x = "batch_size", 
       y = "acc", 
       color = "encoder",
       add = c("mean_se"),
       palette = c("#00AFBB", "#E7B800"))


p
# Assumption check for ANOVA 
# Equality of variances
leveneTestIdentity <- leveneTest(acc ~ batch_size * encoder, data = df_identity)
leveneTestIdentity$`Pr(>F)`[1]



# Normality of residuals 
par(mfrow=c(2,2))
plot(two_way_anova_identity)
par(mfrow=c(1,1))


# Two Way Anova
two_way_anova_identity <- aov(acc ~ batch_size * encoder, data = df_identity)

# Normality of data
aov_residuals <- residuals(object = two_way_anova_identity )
shapiro.test(x = aov_residuals )

# Summary of results
summary(two_way_anova_identity)
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

