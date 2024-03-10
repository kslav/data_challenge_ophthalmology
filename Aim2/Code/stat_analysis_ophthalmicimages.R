library(gplots)
library(ggplot2)
library("tidyverse")
library(data.table)
library(dplyr)

############ LOAD THE FOUR SPREADSHEETS WE ARE GIVEN ############
set.seed(0)
homedir <- "/Users/kalina/Downloads/VeranaHealth/DataChallengeImages/"
dice_df <- read.csv(paste(homedir,"dice_1708153027.725909.csv", sep = ""))
iminfo_df <- read.csv(paste(homedir,"Images info.csv", sep = ""))
metrics_df <- read.csv(paste(homedir,"qualmetrics_1708154411.410247.csv", sep = ""))

# rename the first column across all data frames to be the same as iminfo_df.
# Makes it easier for merging!
colnames(metrics_df)[1] ="ID"
metrics_df["ID"]<-iminfo_df["ID"]
colnames(dice_df)[1] ="ID"
dice_df["ID"]<-iminfo_df["ID"]

# Merge the data frames into one
alliminfo_df <- merge(iminfo_df, dice_df, by.x="ID", by.y="ID")
alliminfo_df <- merge(alliminfo_df,metrics_df,by.x="ID",by.y="ID")

########## RUN STATISTICAL TESTS TO DETERMINE DICE VS. DISEASE STATUS ##########

#[Q]: Does dice score significantly vary when compared between normal and
# healthy retinas?

# We have a small sample size of N=10 healthy and N=10 diseased retinas, so we will
# use the Wilcoxon rank sum non-parametric test to assess difference in the distributions
# of both DICE.Grader1 and DICE.Grader2 when separated by healthy vs. diseased.
# The null hypothesis is that there is no difference in the distributions of dice
# between healthy and diseased groups. The alternative hypothesis is that the DICE
# scores in healthy eyes are greater than the DICE scores in diseased eyes, meaning
# that the vasculature segmentation algorithm performs better in healthy retinas.

# First, we need to convert the "Diagnosis" column to numerical categories. We will
# convert "Normal"-> 0 and everything else to 1.

test_df <- alliminfo_df %>% mutate(across(is.factor, as.numeric)) # temporary df
colnames(test_df)[2]<-"Diagnosis_cat" # we call this new column Diagnosis_cat
for(i in 1:nrow(test_df)){
  if(test_df$Diagnosis_cat[i]==as.numeric(4)){
    test_df$Diagnosis_cat[i]=as.numeric(0)
  } else {
    test_df$Diagnosis_cat[i]=as.numeric(1)
  }
}

#add the categorical diagnosis from temp_df as a column in alliminfo_df
alliminfo_df$Diagnosis_cat <-as.numeric(test_df$Diagnosis_cat) 
disease_status <- alliminfo_df$Diagnosis_cat # get the disease status
# now separate the dice1 (Grader1) and dice2(Grader2) by disease status
dice1_norm <- data.frame(alliminfo_df$DICE.Grader1[disease_status==0]) #normal
dice1_dis <- data.frame(alliminfo_df$DICE.Grader1[disease_status==1]) #diseased
dice2_norm <- data.frame(alliminfo_df$DICE.Grader2[disease_status==0]) #normal
dice2_dis <- data.frame(alliminfo_df$DICE.Grader2[disease_status==1]) #diseased

# Run the wilcoxon rank sum test for dice1 and dice2!
result1 <- wilcox.test(as.numeric(dice1_norm[,1]),as.numeric(dice1_dis[,1]), alternative = "greater")
result2 <- wilcox.test(as.numeric(dice2_norm[,1]),as.numeric(dice2_dis[,1]), alternative = "greater")
# we set "alternative" to "greater" given our alternative hypothesis 

print(paste("For dice1, the p-value is ", result1$p.value, "which is <0.05"))
print(paste("For dice2, the p-value is ", result2$p.value, "which is <0.05"))

print(paste("Mean dice1 for healthy retinas is ",mean(dice1_norm[,1])))
print(paste("Mean dice1 for diseased retinas is ",mean(dice1_dis[,1])))
print(paste("Mean dice2 for healthy retinas is ",mean(dice2_norm[,1])))
print(paste("Mean dice2 for diseased retinas is ",mean(dice2_dis[,1])))

#[A]: For both sets of dice scores, using Grader1 and Grader2 as ground truths,
# we find p<<0.05 (dice1's p-value is 3.789e-05, and dice2's p-value is 0.00053).
# Thus, we can reject the null hypothesis. The dice score is significantly larger
# for segmentations performed in healthy retinas.

########## RUN STATISTICAL TESTS TO DETERMINE DICE VS. IMAGE QUALITY ##########

#[Q]: Does dice score significantly vary with image quality? We can evaluate the
# correlation between these two continuous variables with a correlation coefficient.


# But first, let's quickly plot the dice scores vs. the two image quality metrics. 
# Are they monotonically increasing? Does the relationship look linear? 

# Compare the DICE scores to the BRISQUE metric
plot(alliminfo_df$DICE.Grader1,alliminfo_df$BRISQUE,main="DICE1 vs. BRISQUE",
     xlab="DICE Score (Grader1)",ylab="BRISQUE Score")

plot(alliminfo_df$DICE.Grader2,alliminfo_df$BRISQUE,main="DICE2 vs. BRISQUE",
     xlab="DICE Score (Grader2)",ylab="BRISQUE Score")

# Compare the DICE scores to the blur score

plot(alliminfo_df$DICE.Grader1,alliminfo_df$Blur,main="DICE1 vs. Blur",
     xlab="DICE Score (Grader1)",ylab="Blur Score")

plot(alliminfo_df$DICE.Grader2,alliminfo_df$Blur,main="DICE2 vs. Blur",
     xlab="DICE Score (Grader2)",ylab="Blur Score")

# It's not very clear what the relationship is. We can compute Pearson's correlation
# coefficient as a quick test (acknowledging there may be some error if the distributions
# aren't quite linearly dependent). Again, we're looking for p<0.05 as cut-off 
# for significance.

# First for DICE with Grader1's ground truth:
pears1_brisque <- cor.test(alliminfo_df$DICE.Grader1, alliminfo_df$BRISQUE, method="pearson")
pears1_blur <- cor.test(alliminfo_df$DICE.Grader1, alliminfo_df$Blur, method="pearson")
print(paste("For dice1 using brisque, the p-value is ", pears1_brisque$p.value, "which is >0.05"))
print(paste("For dice1 using blur, the p-value is ", pears1_blur$p.value, "which is >0.05"))

# Then for DICE with Grader2's ground truth:
pears2_brisque <- cor.test(alliminfo_df$DICE.Grader2, alliminfo_df$BRISQUE, method="pearson")
pears2_blur <- cor.test(alliminfo_df$DICE.Grader2, alliminfo_df$Blur, method="pearson")
print(paste("For dice2 using brisque, the p-value is ", pears2_brisque$p.value, "which is >0.05"))
print(paste("For dice2 using blur, the p-value is ", pears2_blur$p.value, "which is >0.05"))

#[A]: All p-values from Pearson's correlation test are above 0.05, so we cannot
# conclude that there is a statistically significant linear relationship between 
# DICE score and image quality metrics, BRISQUE and Blur.