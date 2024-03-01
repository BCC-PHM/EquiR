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

EquiR is an R package designed specifically to streamline the creation of combined heatmap, column, and bar charts within a single graph, tailored for Birmingham City Council's needs. The primary objective of EquiR is to simplify the process of generating such visualizations, offering a range of functions optimised to accommodate various types of data frames provided by users. 

**!!Consider utilising categorical variables for plotting purposes, as it is advisable to convert continuous data into categories prior to utilising the functions.!!** 

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
2.  Multidimensional 
3.  Aggreated level

Different types of data frames require different functions to be used from the `EquiR` pacakge. The following is the demonstration:

### 1.Record level data  
 Record-level data refers to individual entries or observations within a dataset, each representing a distinct unit or instance of information.
 
| ID | Age | Gender | HEIGHT__value | WEIGHT_value | Smoking_status          | Ethnicity_Broad | Outcome      | IMD_decile |
|----|-----|--------|---------------|--------------|--------------------------|-----------------|--------------|------------|
| 1  | 42  | Male   | 1.83          | 84           | Never smoked             | Asian           | Normal       | IMD decile 3+ |
| 24 | 66  | Male   | 1.66          | 72           | Non-smoker - history unknown | Asian     | Pre-diabetic | IMD decile 1 |
| 35 | 41  | Female | 1.515         | 66           | Never smoked             | Asian           | Normal       | IMD decile 1 |
| 41 | 42  | Female | 1.58          | 65           | Never smoked             | Asian           | Normal       | IMD decile 1 |
| 54 | 52  | Male   | 1.73          | 62           | Never smoked             | Asian           | Normal       | IMD decile 3+ |

The function you will need to use from "EquiR" to make the plot is `Ineq_record_level_heatmap()`. The function takes
the following basic arguments:

1.  `data`: A record level data supplied by users 
2.  `col`:  A column from `data` consisting a categorical variable defined by user which will be the column of the heatmap
3.  `row`:  A row from `data` consisting a categorical variable defined by user which will be the row of the heatmap
4.  `coln`: The label to be displayed for the `col` on the graph defined by users
5.  `rown`:  The label to be displayed for the `row` on the graph defined by users
6.  `unit`:   Users defined unit to be displayed on the graph 
7.  `colour`: User defined colour for the graph (Default = `"blue"`)

Therefore, we can generate the graph by running:

``` r
Ineq_record_level_heatmap(data = example_data,
                          col = "Ethnicity_Broad",
                          row = "IMD_decile",
                          coln = "Eth",
                          rown = "IMD",
                          unit = "Count",
                          colour = "blue" )
```
This produces a graph that looks like this:

<div class="figure" style="text-align: center">
<img src="https://github.com/BCC-PHM/EquiR/assets/98521529/0d8ebd8e-79ec-4ab3-87a3-bf704c6643dc" width="700">
<p class="caption">
</p>

</div>

### 2.Multidimensional data
Multidimensional data refers to datasets or information that contain multiple variables or dimensions(>=3), while a single column summarises the number of observations corresponding to individuals meeting specific conditions.

| LA Code | LA | Ethnic_group | Economic_inactive          | Age                    | Observation |
|-----------------------------------|-------------------------------|--------------|-----------------------------|------------------------|-------------|
| E08000025                         | Birmingham                    | White        | Retired                     | Aged 65 years and over | 97864       |
| E08000025                         | Birmingham                    | Asian        | Student                     | Aged 16 to 24 years    | 30507       |
| E08000025                         | Birmingham                    | White        | Student                     | Aged 16 to 24 years    | 28167       |
| E08000025                         | Birmingham                    | Asian        | Looking after home or family | Aged 35 to 49 years    | 18123       |
| E08000025                         | Birmingham                    | Asian        | Retired                     | Aged 65 years and over | 16280       |
| E08000025                         | Birmingham                    | White        | Long-term sick or disabled  | Aged 50 to 64 years    | 13759       |
| E08000025                         | Birmingham                    | White        | Retired                     | Aged 50 to 64 years    | 10661       |
| E08000025                         | Birmingham                    | Black        | Student                     | Aged 16 to 24 years    | 10010       |

The function you will need to use from "EquiR" to make the plot is `Ineq_multidi_level_heatmap()`. The function takes
the following basic arguments:

1.  `data`: A Multidimensional data supplied by users 
2.  `col`:  A column from `data` consisting a categorical variable defined by user which will be the column of the heatmap
3.  `row`:  A row from `data` consisting a categorical variable defined by user which will be the row of the heatmap
4.  `value`: The variable that contains the sum of observations 
5.  `coln`: The label to be displayed for the `col` on the graph defined by users
6.  `rown`:  The label to be displayed for the `row` on the graph defined by users
7.  `unit`:   Users defined unit to be displayed on the graph 
8.  `colour`: User defined colour for the graph (Default = `"blue"`)

Therefore, we can generate the graph by running:

``` r
Ineq_multidi_level_heatmap(data = example_data2, 
                           col = "Ethnic_group", 
                           row = "Age", 
                           value= "Observation",
                           coln = "Eth", 
                           rown = "Age gp", 
                           unit = "Count", 
                           colour = "red")
```
This produces a graph that looks like this:
<div class="figure" style="text-align: center">
<img src="https://github.com/BCC-PHM/EquiR/assets/98521529/71887ebb-7e02-4592-8b2c-08a5848b8fbe" width="700">
<p class="caption">
</p>
</div>

### 3.Aggreated level data
Aggregated level data within this package refers to information that has been combined or summarised from individual-level data to provide a higher-level perspective or summary. This dataframe is designed to include only two columns of categorical variables and one column for observations. 
| Ethnicity | reason                         | Values |
|-----------|--------------------------------|--------|
| White     | Retired                        | 108806 |
| Asian     | Looking after home or family   | 38004  |
| Asian     | Student                        | 34357  |
| Black     | Student                        | 31371  |
| White     | Long-term sick or disabled     | 28841  |
| White     | Looking after home or family   | 21297  |
| Other     | Retired                        | 18448  |

The function you will need to use from "EquiR" to make the plot is `Ineq_aggregated_level_heatmap()`. The function takes
the following basic arguments:

1.  `data`: An Aggreated level data supplied by users 
2.  `col`:  A column from `data` consisting a categorical variable defined by user which will be the column of the heatmap
3.  `row`:  A row from `data` consisting a categorical variable defined by user which will be the row of the heatmap
4.  `value`: The variable that contains the sum of observations 
5.  `coln`: The label to be displayed for the `col` on the graph defined by users
6.  `rown`:  The label to be displayed for the `row` on the graph defined by users
7.  `unit`:   Users defined unit to be displayed on the graph 
8.  `colour`: User defined colour for the graph (Default = `"blue"`)

Therefore, we can generate the graph by running:

``` r
Ineq_multidi_level_heatmap(data = example_data3, 
                           col = "Ethnicity", 
                           row = "reason", 
                           value= "Values",
                           coln = "Eth", 
                           rown = "reason", 
                           unit = "Count", 
                           colour = "blue")
```
This produces a graph that looks like this:

<div class="figure" style="text-align: center">
<img src="https://github.com/BCC-PHM/EquiR/assets/98521529/9b88919c-899c-444b-ac87-dbe93451c0c7" width="700">
<p class="caption">
</p>
</div>

## Customising your graph

### Colour palette

We can also change the colour palette by setting the `colour` argument.
The default is set to `"blue"` and currently only two more palette are available namely `"red"` and `"green"`.
