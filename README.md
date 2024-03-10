#OVERVIEW: This was a data challenge -- to be completed within 40 hours -- composed of two aims based on the analysis of simulated patient data. These two aims are as follows: 
* <ins>Aim 1</ins>: Assess the relationship between the number of cigarettes smoked per day and the prevalence of diabetes in a set of over 4,000 patients.
* <ins>Aim 2</ins>: Design a segmentation algorithm for segmenting retinal vasculature from ophthalmic images, using two sets of ground truth segmentations for evaluation.

All files and data associated with each aim are stored under the folders **Aim1** and **Aim2**, respectively. A summary of all analyses and key findings for both aims is presented in *Slavkova_Report_DataChallenge.pdf* in the main branch.

##Getting started with Aim1

##Getting started with Aim2
Within the Aim2 folder, you will find the following subfolders:
<ins>Data</ins>: Contains the raw RGB ophthalmic images under **Raw images**, the ground truth segmentations from Grader 1 under **Grader1**
, the ground truth segmentations from Grader 2 under **Grader2**, and a CSV of information corresponding to each raw image as *Image info.csv*
<ins>Code</ins>: Contains a jupyter notebook (*retinal_vasculature_segmentation.ipynb*) that loads the images and performs segmentation and a script in R (stat_analysis_ophthalmicimages.R) to perform statistical analysis of the segmentation results and image quality. 
<ins>Results</ins>: A place for storing the resultant dice scores and image quality metrics from running *retinal_vasculature_segmentation.ipynb*
