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

These data sets can be viewed by calling `data()`:

`data(package="fluxweb")`

They all have the generally the same structure, a list of five items:

       $mat: a binary feeding matrix of *i* resources (rows) and *j*
consumers (columns)  
       $biomasses: vector of standing biomass for each node  
       $bodymasses: vector of body sizes for each node  
             Alternatively, this could be $met.rate: vector of metabolic
rates for each node  
       $efficiencies: vector of feeding efficiencies. What this values
represents (e.g., assimilation efficiency, gross production efficiency,
etc.) depends on the loss term used in *bodymasses*  
       $names: vector of names for the rows/columns  
             Alternatively, this can be a data.frame with species names,
some trophic grouping, trophic level, etc. (see `groups.level` in
example).

<center>

Figure 2. Feeding interaction matrix of the simplified case (Fig. 1c).
Food resources are represented as rows and consumers are
columns.

|                     | Gammarus mucronatus | Bittium varium | Macroalgae | Palaemonetes spp. |
| ------------------- | ------------------: | -------------: | ---------: | ----------------: |
| Gammarus mucronatus |                   0 |              0 |          0 |                 1 |
| Bittium varium      |                   0 |              0 |          0 |                 1 |
| Macroalgae          |                   1 |              1 |          0 |                 0 |
| Palaemonetes spp.   |                   0 |              0 |          0 |                 0 |

</center>

We will first walk through the simple case. Loading in the example as a
list of length five(5):

``` r
simple = simple.case
```

We have already explored the contents of the list above as well as the
structure of the feeding matrix (Fig. 2), but for a reminder the five
items are: ‘mat’ - feeding matrix (4 x 4), ‘met.rate’ - metabolic rates
of each node (numeric vector, length = 4), ‘biomasses’ - the biomass of
each node (numeric vector, length = 4), ‘efficiencies’ - efficiency of
feeding links (numeric vector, length = 4), and ‘names’ - the names for
each node (character vector, length = 4).

But let’s look at the other items:

``` r
names(simple$met.rate) <- simple$names
simple$met.rate
```

    ## Gammarus mucronatus      Bittium varium          Macroalgae 
    ##        9.130425e-06        1.205617e-05        4.580287e-02 
    ##   Palaemonetes spp. 
    ##        3.056306e+01

Importantly, this is total summed annual metabolic rates in J/year.
Therefore when we run the simple.case in the `fluxing()` function, we
should set `bioms.losses = FALSE`. If we set this to `TRUE`, the
metabolic rates are multiplied by the biomasses.

``` r
names(simple$biomasses) <- simple$names
simple$biomasses
```

    ## Gammarus mucronatus      Bittium varium          Macroalgae 
    ##              0.7900            120.9925           4557.5000 
    ##   Palaemonetes spp. 
    ##             32.7000

``` r
names(simple$efficiencies) <- simple$names
simple$efficiencies
```

    ## Gammarus mucronatus      Bittium varium          Macroalgae 
    ##               0.545               0.545               1.000 
    ##   Palaemonetes spp. 
    ##               0.906

We have everything we need now to run the basic flux
estimation:

``` r
mat.fluxes <- fluxing(mat = simple$mat, biomasses  = simple$biomasses, losses = simple$met.rate, efficiencies = simple$efficiencies, bioms.prefs = FALSE, bioms.losses = FALSE, ef.level = "pred")
```

`mat.fluxes` is a 4 x 4 matrix that is the material flux from resources
(rows) to consumers (columns).

Figure 3. Material flux matrix from resources (rows) to consumers
(columns).

``` r
colnames(simple$mat) <- rownames(simple$mat) <- simple$names
knitr::kable(t(mat.fluxes))
```

|                     | Gammarus mucronatus | Bittium varium | Macroalgae | Palaemonetes spp. |
| ------------------- | ------------------: | -------------: | ---------: | ----------------: |
| Gammarus mucronatus |           0.0000000 |      0.0000000 |          0 |         0.0420377 |
| Bittium varium      |           0.0000000 |      0.0000000 |          0 |         0.0420431 |
| Macroalgae          |           0.0229014 |      0.0229014 |          0 |         0.0000000 |
| Palaemonetes spp.   |           0.0000000 |      0.0000000 |          0 |         0.0000000 |

In the species-level (a) and simple cases (c) the feeding is based on
relative abundance of prey types. This is done by setting a feeding
connection to ‘1’, meaning a feeding interaction exists, but there is
not preference for the prey item. Therefore, feeding rates are just
based on relative abundance in the
model.

<!-- stepping through the example of moderate complexity that has some aggregation of prey and food items is the most useful to understand how we can alter the interactions to  -->
