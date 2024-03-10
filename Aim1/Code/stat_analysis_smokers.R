library(gplots)
library(ggplot2)
library("tidyverse")
library(data.table)

############ LOAD THE FOUR SPREADSHEETS WE ARE GIVEN ############
set.seed(0)
homedir <- "~/Aim1/Data/"
pat_clinical <- read.csv(paste(homedir,"patient_clinical.csv", sep = ""))
pat_dem <- read.csv(paste(homedir,"patient_demographics.csv", sep = ""))
pat_hist <- read.csv(paste(homedir,"patient_history.csv", sep = ""))
pat_notes <- read.csv(paste(homedir,"patient_note.csv", sep = ""))

# [Q]: Is there overlap in the cases among these tables? 
clin_dem <- merge(pat_clinical, pat_dem, by.x="patient_id", by.y="patient_id")
clin_dem <- na.omit(clin_dem) # remove cases with any NaNs
# Yes, all of pat_clinical overlaps with pat_dem!

clin_dem_hist <- merge(clin_dem,pat_hist,by.x="patient_id",by.y="patient_id")
clin_dem_hist <- na.omit(clin_dem_hist) # remove cases with any NaNs
# Yes, though a few cases did not overlap. 

# [Q]: How many positive outcomes of outcomes, like TenYearCHD and diabetes are 
# there compared to negative outcomes?

chd_prev <- sum(as.numeric(clin_dem_hist$TenYearCHD,na.rm=TRUE)) #553 with CHD
diab_prev <- sum(as.numeric(clin_dem_hist$diabetes,na.rm=TRUE)) #99 diabetic
smok_prev <- sum(as.numeric(clin_dem_hist$currentSmoker,na.rm=TRUE)) #1780 smoke

################## OBSERVATIONS OF THE DATA ##################
# pat_clinical: 4231 observations (cases) of 9 variables. A potential clinical 
# outcome of interest is the presence of coronary heart disease (CHD) at 10 year followup

# pat_dem: 4240 observations of 4 variables. Gender, age, and education are
# reported, but the meaning of the education values are not defined, so it would
# be difficult to interpret any findings related to education without knowing 
# what these education values mean. 

# pat_hist: 4229 observations of 4 variables. This table reports whether the 
# subject currently smokes, takes BP meds, smokes some number of cigarettes per 
# day, has had a stroke, has hypertension, and has diabetes.

# pat_notes: 2611 observations of 1 variable, namely notes from a clinician
# during an exam. These notes vary greatly, and the assumption is that these
# notes come from more than 1 care provider.

# We were able to merge the clinical, demographics, and history datasets, yielding
# N=3640 cases with 18 (17 excluding patient_ids) total variables (after removing
# rows with nans). If we need to analyze patient notes, we need to consider that
# it would severely decrease our N value since patient notes only has information 
# available for 2611 patients.

# Among the 4229 cases that for whom we we have clinical, demographic, and 
# historic inform, we observe 553 with CHD at 10 year follow up and only 99 who
# are diabetic among 2085 who are current smoker/smoke more than 1 cigarette daily.
# This tells us it might be hard to do classification tasks or design good ML 
# models if we wanted to do prediction of diabetes given smoking status. A good
# ratio of classes is roughly 1:10-1:20, so 553 could be enough for building models for CHD
# prediction, but 99 diabetic cases will require some bias correction and/or class
# imbalance remedies for such a prediction task (ratio closer to 1:33). 

# In any case, we only want to know if there is a correlation between cigarettes
# smoked per day and diabetic prevalence. 

########## PLOT THE RELATIONSHIP BETWEEN DIABETES AND CIGARETTE USE ##########

# first let's quickly look at the distribution of cigsPerDay over total population
cigsPerDay <- clin_dem_hist$cigsPerDay
plot_title <- "Frequency of number of cigarettes smoked daily"
x_lab <- "Cigarettes per day"
hist(cigsPerDay,main = plot_title ,xlab=x_lab, freq=FALSE)

# next let's plot the cigarettes smoked by day when stratified by diabetic status
# We will plot a density plot so that the two distributions are on the same scale

# Create our dataframes for cigarettes per day by diabetic and non-diabetic status:
diab_status <- clin_dem_hist$diabetes
cigs_diab <- data.frame(cigsPerDay[diab_status==1]) # positive diabetic status
cigs_nondiab <- data.frame(cigsPerDay[diab_status==0]) # negative diabetic status

# Make sure our column names are the same in each dataframe
cigs_diab$Status <- 'Diabetic'
cigs_nondiab$Status <- 'Non-diabetic'
colnames(cigs_diab)[1] ="Cigarettes_Per_Day"
colnames(cigs_nondiab)[1] ="Cigarettes_Per_Day"

# Combine cigs_diab and cigs_nondiab for plotting!
toplot <- rbind(cigs_diab,cigs_nondiab)
ggplot(toplot, aes(Cigarettes_Per_Day, fill = Status)) + geom_density(alpha = 0.2)

#What are the means/ranges/IQRs of the two groups? (Median=0 in both cases, highly skewed)
mean_diab <- mean(as.numeric(cigs_diab$Cigarettes_Per_Day))
mean_nondiab <- mean(cigs_nondiab$Cigarettes_Per_Day)
range_diab<-range(as.numeric(cigs_diab$Cigarettes_Per_Day))
range_nondiab<-range(as.numeric(cigs_nondiab$Cigarettes_Per_Day))
iqr_diab<-IQR(as.numeric(cigs_diab$Cigarettes_Per_Day))
iqr_nondiab<-IQR(as.numeric(cigs_nondiab$Cigarettes_Per_Day))

########## RUN A STATISTICAL TEST TO DETERMINE SIGNIFICANCE ##########

#[Q]: What is the significance of the relationship between cigarettes smoked
# per day and diabetes prevalence?

# It's clear from our plot that our two distributions are not normally distributed.
# We can use a non-parametric test to determine whether the distributions of 
# our two vectors of data with different-lengths are significantly different.
# An appropriate choice is the Wilcoxon rank sum test (Mann-Whitney U), which is the
# non-parametric version of the unpaired t-test. The null hypothesis in our case
# is that the the number of cigarettes smoked per day in the diabetic 
# group is not larger than the number of cigarettes smoked per day in the non-diabetic
# group. We will use p<0.05 as the cut-off level of significance. Our alternative
# hypothesis is that the number of cigarettes smoked per day is greater in the 
# diabetic group than the number of cigarettes smoked per day in the non-diabetic
# group. The assumption is that smoking is harmful and is a risk factor in the
# development of diabetes, and the more cigarettes a person smokes, the greater
# the risk and prevalence of diabetes. Thus, we want to evaluate a one-sided p-value
# using the rank sum test.

result <- wilcox.test(as.numeric(cigs_diab$Cigarettes_Per_Day),as.numeric(cigs_nondiab$Cigarettes_Per_Day), alternative = "greater")
# we set "alternative" to "greater" given our alternative hypothesis described
# just above.

print(paste("The p-value is ", result$p.value, "which is >0.05"))

#[A]: The resultant p-value is p=0.9926, which is greater than the cut-off of 0.05.
# Thus, we accept the null hypothesis outlined above and reject the alternative.

#[Q]: What if we test the alternative hypothesis that the diabetic group actually
# smokes less cigarettes per day than the non-diabetic group?

result_alt <- wilcox.test(as.numeric(cigs_diab$Cigarettes_Per_Day),as.numeric(cigs_nondiab$Cigarettes_Per_Day), alternative = "less")
# we set "alternative" to "lesserr" given our new alternative hypothesis.
# just above.

print(paste("The p-value is ", result_alt$p.value, "which is >0.05"))

#[A]: In this case, the cigarettes smoked per day in the diabetic group skews
# significantly lower than the cigarettes smoked per day in the non-diabetic gropu.
# This could suggest that patients with diabetes smoke less potentially due to 
# proper disease management and development of healthier habits, like cutting back
# on smoking. More information must be collected, like longitudinal assessment of
# smoking over time and onset of positive diabetic status.