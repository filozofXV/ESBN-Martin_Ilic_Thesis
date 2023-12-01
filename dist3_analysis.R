# Distribution-of-three task

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
setwd("./test/dist3/batchconv32/ESBN_contextnorm_lr0.0005")


# Create a vector, and load data from the folder which 
# are in separate .txt files (run1.txt, run2.txt, ...)
dist3_batchconv32 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv32 <- c(dist3_batchconv32, run_i$acc)
}

# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv16/ESBN_contextnorm_lr0.0005")

dist3_batchconv16 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv16 <- c(dist3_batchconv16, run_i$acc)
}

# 8 batch size 
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv8/ESBN_contextnorm_lr0.0005")

dist3_batchconv8 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv8 <- c(dist3_batchconv8, run_i$acc)
}

# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchconv4/ESBN_contextnorm_lr0.0005")

dist3_batchconv4 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchconv4 <- c(dist3_batchconv4, run_i$acc)
}

# RANDOM ENCONDER - Loading of data
#------------------------------------
# 32 batch size

setwd(dirname(getActiveDocumentContext()$path))  
setwd("./batchrand32/ESBN_contextnorm_lr0.0005")

dist3_batchrand32 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand32 <- c(dist3_batchrand32, run_i$acc)
}

# 16 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand16/ESBN_contextnorm_lr0.0005")

dist3_batchrand16 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand16 <- c(dist3_batchrand16, run_i$acc)
}

# 8 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand8/ESBN_contextnorm_lr0.0005")

dist3_batchrand8 <- c()

for (i in 1:10) {
  run_i <- read.delim(paste("run",as.character(i),".txt", sep = ""), header = T, sep = " ")
  dist3_batchrand8 <- c(dist3_batchrand8, run_i$acc)
}

# 4 batch size
setwd(dirname(getActiveDocumentContext()$path))  
setwd("./test/dist3/batchrand4/ESBN_contextnorm_lr0.0005")

dist3_batchrand4 <- c()

for (i in 1:10) {
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

# Show the number of data points in each condition pair 
table(df_dist3$batch_size, df_dist3$encoder)

# Visualize the data trend, along with their standard error and means 
p <- ggline(df_dist3, 
            title = "Plot of test accuracy by encoder and batch size conditions",
            xlab = "Batch size",
            ylab = "Accuracy",
            x = "batch_size", 
            y = "acc", 
            color = "encoder",
            add = c("mean_se"),
            palette = c("#00AFBB", "#E7B800"))

p


# Two Way Anova
two_way_anova_dist3 <- aov(acc ~ batch_size * encoder, data = df_dist3)

# Summary of results
summary(two_way_anova_dist3)
model.tables(two_way_anova_dist3, type="means", se = TRUE)



# Assumption check for ANOVA 
# Equality of variances
leveneTestIdentity <- leveneTest(acc ~ batch_size * encoder, data = df_dist3)
leveneTestIdentity$`Pr(>F)`[1]

# Normality of data
aov_residuals <- residuals(object = two_way_anova_dist3)
shapiro.test(x = aov_residuals )

# Normality of residuals 
par(mfrow=c(2,2))
plot(two_way_anova_dist3)
par(mfrow=c(1,1))

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
  batch_size32_conv_rand = c(0,0,0,-1,0,0,0,1),
  batch_size4_conv_rand  = c(-1,0,0,0,1,0,0,0)
)

# Perform post hoc tests
posthoc_dist3 <- contrast(estimated_marginal_means_dist3, contrasts_dist3, adjust = "bonf")

posthoc_dist3