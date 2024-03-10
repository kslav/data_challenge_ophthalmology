## OVERVIEW: 
This was a data challenge -- to be completed within 40 hours -- composed of two aims based on the analysis of simulated patient data. These two aims are as follows: 
* <ins>Aim 1</ins>: Assess the relationship between the number of cigarettes smoked per day and the prevalence of diabetes in a set of over 4,000 patients.
* <ins>Aim 2</ins>: Design a segmentation algorithm for segmenting retinal vasculature from ophthalmic images, using two sets of ground truth segmentations for evaluating segmentation quality.

All files and data associated with each aim are stored under the folders **Aim1** and **Aim2**, respectively. A summary of all analyses and key findings for both aims is presented in *Slavkova_Report_DataChallenge.pdf* in the main branch.

## Getting started with Aim1

## Getting started with Aim2
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
9. To inspect the relationship between dice scores and image quality metric, run the R script, *stat_analysis_ophthalmicimages.R*, with your IDE of choice (like RStudio).
