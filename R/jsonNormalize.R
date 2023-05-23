#' @title Normalize a JSON string
#' @description Attempts to normalize or fix a JSON string.
#'
#' @param jstring a character string, the JSON string to be normalized
#'
#' @return The normalized JSON string.
#' @export
#' @import V8
#' @examples
#' library(jsonNormalize)
#' # the keys of the following JSON string are not quoted
#' jstring <- "[{area:30,ind:[5,4.1,3.7],cluster:true},{ind:[],cluster:false}]"
#' jsonNormalize(jstring)
jsonNormalize <- function(jstring) {
  ctx <- v8()
  ctx$source(system.file("js", "jsonNormalize.js", package = "jsonNormalize"))
  ctx$assign("x", jstring)
  ctx$eval("var normalizedJstring = normalize(x);")
  ctx$get("normalizedJstring")
}
