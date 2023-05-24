jsonNormalize
================

<!-- badges: start -->

[![R-CMD-check](https://github.com/stla/jsonNormalize/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/stla/jsonNormalize/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Normalize JSON strings.

------------------------------------------------------------------------

``` r
library(jsonNormalize)

badJstring <- "
[
  { 01: false, 999: true },
  {
    area: 30,
    thirty: '30',
    ind: [5, 4.1,   3.7 , 1e3],
    'cluster'    : true  ,
    \"999\": false,
    city: 'London'
  },
  [ null, undefined,   NaN],
  {
    'null': null,
    'undefined': undefined,
    'NaN': NaN
  }
]"
goodJstring <- jsonNormalize(badJstring, prettify = TRUE)
cat(goodJstring)
```

    [
      {
        "999": true,
        "01": false
      },
      {
        "999": false,
        "area": 30,
        "thirty": "30",
        "ind": [
          5,
          4.1,
          3.7,
          1000
        ],
        "cluster": true,
        "city": "London"
      },
      [
        null,
        "",
        ""
      ],
      {
        "null": null,
        "undefined": "",
        "NaN": ""
      }
    ]
