fluxweb Workflow
================
Jim Junker
January 10, 2019

Here is a step-by-step introduction to working with the fluxweb package,
assciated data, and another novel example. First steps are to install
and load the package:

`install.packages("fluxweb")`

Load the package

`library(fluxweb)`

The *fluxweb* package comes with three data sets that represent three
levels of complexity–from a species-specific level with 62 individual
nodes to a simple case with four aggregated groupings (Figure 1).

![configurations of data sets found in the fluxweb
package](C:/Users/Junker/Documents/Projects/fluxweb_exploratory/README-files/Gauzens-et-al-2017_fig-1.png)

These data sets can be viewed by calling `data()` function:

`data(package="fluxweb")`

They all have the same structure, a list of five items:

       $mat: a binary feeding matrix of *i* resources (rows) and *j*
consumers (columns)  
       $biomasses: vector of standing biomass for each node  
       $bodymasses: vector of body sizes for each node  
             Alternatively, this could be $met.rate: vector of metabolic
rates for each node  
       $efficiencies: vector of feeding efficiencies. What this values
represents (e.g., assimilation efficiency, gross production efficiency,
etc.) depends on the loss term used in *bodymasses*

|   |   |   |   |
| -: | -: | -: | -: |
| 0 | 0 | 1 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 0 | 0 | 0 |
| 1 | 1 | 0 | 0 |

The species-level and simple cases are binary, connectance webs. They
only show if a feeding interaction exists, there are no consumer diets
preferences. Therefore, we first walk through the example of mdderate
complexity that has some aggregation of fo
