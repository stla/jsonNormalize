% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/jsonNormalize.R
\name{jsonNormalize}
\alias{jsonNormalize}
\title{Normalize a JSON string}
\usage{
jsonNormalize(jstring, prettify = FALSE, to = NULL)
}
\arguments{
\item{jstring}{a character string, the JSON string to be normalized, or
the path to a JSON file}

\item{prettify}{Boolean, whether to prettify the normalized JSON string}

\item{to}{\code{NULL} to return the normalized JSON string, otherwise
the path to a JSON file to which the normalized JSON string will be
written}
}
\value{
The normalized JSON string.
}
\description{
Attempts to normalize or fix a JSON string. Trailing commas
 are removed, and all keys of the normalized JSON string are double-quoted.
}
\note{
The special JavaScript values \code{undefined} and \code{NaN} are not
  allowed in JSON strings. If one of them occurs in the input string, it is
  replaced by the empty string.
}
\examples{
library(jsonNormalize)
# the keys of the following JSON string are not quoted
jstring <- "[{area:30,ind:[5,3.7], cluster:true,},{ind:[],cluster:false},]"
cat(jsonNormalize(jstring, prettify = TRUE))
}
