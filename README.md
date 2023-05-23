jsonNormalize
================

Normalize JSON strings.

------------------------------------------------------------------------

``` r
library(jsonNormalize)

cat(jsonNormalize("{'999': true}"))
```

    {"999":true}

``` r
badJstring <- "
[
  { 01: false, 999: true },
  {
    area: 30,
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
