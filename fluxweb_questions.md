Fluxweb workthru
================
Jim Junker
February 22, 2019

First load packages:

``` r
library(fluxweb)
library(knitr)
```

Now set the column names and rownames of the example matrix and view it:

Figure 1. Food web interaction matrix between resources (rows) and
consumers
(columns).

``` r
colnames(simple.case$mat) <- rownames(simple.case$mat) <- simple.case$names
knitr::kable(simple.case$mat)
```

|                     | Gammarus mucronatus | Bittium varium | Macroalgae | Palaemonetes spp. |
| ------------------- | ------------------: | -------------: | ---------: | ----------------: |
| Gammarus mucronatus |                   0 |              0 |          1 |                 0 |
| Bittium varium      |                   0 |              0 |          1 |                 0 |
| Macroalgae          |                   0 |              0 |          0 |                 0 |
| Palaemonetes spp.   |                   1 |              1 |          0 |                 0 |

This looks weird, as it suggest Macroalgae are eating Gammarus and
Bittium and the predatory grass shrimp, Palaemonetes, is eating nothing.

I think this is simply that the matrix is
transposed:

``` r
knitr::kable(t(simple.case$mat))
```

|                     | Gammarus mucronatus | Bittium varium | Macroalgae | Palaemonetes spp. |
| ------------------- | ------------------: | -------------: | ---------: | ----------------: |
| Gammarus mucronatus |                   0 |              0 |          0 |                 1 |
| Bittium varium      |                   0 |              0 |          0 |                 1 |
| Macroalgae          |                   1 |              1 |          0 |                 0 |
| Palaemonetes spp.   |                   0 |              0 |          0 |                 0 |
