## OVERVIEW: 
This was a data challenge -- to be completed within 40 hours -- composed of two aims based on the analysis of simulated patient data. These two aims are as follows: 
* <ins>Aim 1</ins>: Assess the relationship between the number of cigarettes smoked per day and the prevalence of diabetes in a set of over 4,000 patients.
  * Q1: Spend some time exploring the tables data and show or discuss what you find. What are the types of data quality issues will have to consider?
  * Q2: Is there a relationship between the number of cigarettes smoked per day and the prevalence of diabetes? Run a statistical test to determine significance, interpret the results and create a visualization to display this. 
* <ins>Aim 2</ins>: Design a segmentation algorithm for segmenting retinal vasculature from ophthalmic images, using two sets of ground truth segmentations for evaluating segmentation quality.
  * Q1: Explain your rationale in designing the algorithm, choosing the evaluation metrics and discuss how your algorithm outputs compared to the two graders’.
  * Q2: Does your algorithm perform differently between images from normal eyes and diseased eyes?
  * Q3: Assess the image quality of this dataset, does image quality influence your algorithm performance?
  * Q4: This small set of images were provided to you to assess the feasibility of building a deep learning model to perform the same task with additional images, based on the analysis you performed above, is it feasible? What additional images and or additional workflows need to be implemented?

All files and data associated with each aim are stored under the folders **Aim1** and **Aim2**, respectively. A summary of all analyses and key findings addressing the questions for both aims is presented in *Slavkova_Report_DataChallenge.pdf* in the main branch.

## Getting started with Aim 1
Within the Aim1 folder, you will find the following subfolders:
* <ins>Data</ins>: Contains four CSV files of simualted patient information, including clinical variables, demographic information, patient history, and clinician notes.
* <ins>Code</ins>: Contains one R script, *stat_analysis_smokers.R*, which runs all analyses on the data under **Data**.

To reproduce the analysis, please follow these steps:
1. Ensure that your system satisfies the following R requirements:
   * R version 3.6.2 or greater
   * R packages: gplots, ggplot2, tidyverse, data.table
   * RStudio Version 2022.12.0+353 or greater (ideal for visualizing results)
2. Open *stat_analysis_smokers.R* in RStudio (or other IDE of choice) and set `homedir <- [path of repo on your machine]/Aim1/Data/`
3. Run the entire script with `CMD + Shift + Enter/Return`. Plots in RStudio will be visualized in the lower right corner

## Getting started with Aim 2
Within the Aim2 folder, you will find the following subfolders:
* <ins>Data</ins>: Contains the raw RGB ophthalmic images under **Raw images**, the ground truth segmentations from Grader 1 under **Grader1**
, the ground truth segmentations from Grader 2 under **Grader2**, and a CSV of information corresponding to each raw image as *Image info.csv*
* <ins>Code</ins>: Contains a jupyter notebook (*retinal_vasculature_segmentation.ipynb*) that loads the images and performs segmentation and a script in R (*stat_analysis_ophthalmicimages.R*) to perform statistical analysis of the segmentation results and image quality. 
* <ins>Results</ins>: A place for storing the resultant dice scores and image quality metrics from running *retinal_vasculature_segmentation.ipynb*

To reproduce the analysis, please follow these steps: 
1. Ensure that your system satisfies the following python and R requirements:
   * Python version 3.9.12 or greater
   * R version 3.6.2 or greater
2. Clone the repo to your home directory so that `homedir=[path of the repo on your machine]`
3. Navigate to the **Code** folder and create a Python virtual environment using `python -m venv [homedir]/Aim2/Code/[name of virtual environment]`. Activate your new virtual environment using `source [path of virtual environment]/bin/activate`
4. Install all packages in *requirements.txt* using `pip install -r requirements.txt`
5. Before running Jupyter Notebook, ensure that you've added your new virtual environment to Jupyter Notebook with the command `python -m ipykernel install --user --name=[name of virtual environment]`
6. Open Jupyter Notebook in your browser with the command `jupyter notebook` and run *retinal_vasculature_segmentation.ipynb*. Make sure your kernel is set to the virtual environment by going to the **Kernel** tab and navigating to **Change kernel** in the dropdown menu.
7. In the second code cell of *retinal_vasculature_segmentation.ipynb*, headed by `# SETTING THE HOMEDIR`, change your homedir to *[homedir]/Aim2/*.
   * Run the notebook (the dice scores and image equality metrics are saved as CSV files in the **Results** folder.).
   * Make sure to shut down Jupyter Notebook when finished and to deactivate your virtual environment. 
9. To inspect the relationship between dice scores and image quality metric, run the R script, *stat_analysis_ophthalmicimages.R*, with your IDE of choice (like RStudio). Make sure to update `homedir` and `datadir` on lines 9 and 10 with the correct directories on your machine.
