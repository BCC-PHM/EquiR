---
output:
  html_document: default
  pdf_document: default
---

# EquiR

GitHub: [EquiR](https://github.com/BCC-PHM/EquiR)

Chung Au-Yeung - BCC PHM

Late Updated: 2024-02-29

## Introduction

### What is EquiR?

EquiR is an R package designed  specifically to streamline the creation of combined heatmap, column, and bar charts within a single graph, tailored for Birmingham City Council's needs. The primary objective of EquiR is to simplify the process of generating such visualizations, offering a range of functions optimised to accommodate various types of data frames provided by users.

<div class="figure" style="text-align: center">
<img src="https://github.com/BCC-PHM/EquiR/assets/98521529/0d8ebd8e-79ec-4ab3-87a3-bf704c6643dc" width="700">
<p class="caption">
EquiR example using NHS Health Checks data
</p>

</div>

## EquiR basics

### Installing EquiR

The package can be installed the from GitHub by typing the following command into the RStudio console:

``` r
devtools::install_github("BCC-PHM/EquiR")
```

`EquiR` will automatically download any missing prerequisite
libraries so this may take a few minutes the first time running it on
your machine.

### Loading EquiR

Once installed, you can open a new file by clicking the icon in the top left corner of RStudio underneath "file". In this new script, you can load the library at the start of a new R script using the following function. 

``` r
library("EquiR")
```

### Data requirements 

The `EquiR` pacakge supports three types of data frames provided by the users and they are:

1.  Record level
2.  multidimensional 
3.  Aggreated level

Different types of data frames require different functions to be used from the `EquiR` pacakge. The following is the demonstration 

### 1.Record level data  
 
 | ID | Age | Gender | HEIGHT_value | WEIGHT_value | ALCOHOL_value | TC2HDL | HBA1C_value | Smoking_status   |
|----|-----|--------|--------------|--------------|----------------|--------|--------------|------------------|
| 1  | 42  | Male   | 1.83         | 84           | 4              | 5.2    | 42           | Never smoked     |
| 24 | 66  | Male   | 1.66         | 72           | 0              | 3.5    | 44           | Non-smoker - history unknown |
| 35 | 41  | Female | 1.515        | 66           | NA             | 5.3    | 35           | Never smoked     |
| 41 | 42  | Female | 1.58         | 65           | 0              | 5.4    | 36           | Never smoked     |
| 54 | 52  | Male   | 1.73         | 62           | 0              | 3.9    | 40           | Never smoked     |
| 56 | 65  | Male   | 1.64         | 65           | 0              | 3.5    | 36           | Never smoked     |
| 59 | 57  | Female | 1.51         | 85.4         | 0              | 3.5    | 45           | Never smoked     |
| 80 | 44  | Male   | 1.69         | 55.5         | NA             | 5.6    | 40           | Current smoker   |
| 89 | 48  | Female | 1.61         | 80           | 0              | 5.2    | 32           | Never smoked     |
| 105| 45  | NA     | 1.83         | 84           | 0              | 4.1    | 38           | Current smoker   |
