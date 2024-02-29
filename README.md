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
