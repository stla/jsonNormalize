jsonNormalize
================

Normalize JSON strings.

------------------------------------------------------------------------

``` r
library(jsonNormalize)

badJstring <- "
[
  {
    area: 30,
    ind: [5, 4.1,   3.7 , 1e3],
    'cluster'    : true
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
        "area": 30,
        "ind": [
          5,
          4.1,
          3.7,
          1000
        ],
        "cluster": true
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
