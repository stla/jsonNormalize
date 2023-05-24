#' @title Normalize a JSON string
#' @description Attempts to normalize or fix a JSON string.
#'
#' @param jstring a character string, the JSON string to be normalized
#' @param prettify Boolean, whether to prettify the normalized JSON string
#'
#' @return The normalized JSON string.
#' @export
#' @import V8
#' @examples
#' library(jsonNormalize)
#' # the keys of the following JSON string are not quoted
#' jstring <- "[{area:30,ind:[5,4.1,3.7],cluster:true},{ind:[],cluster:false}]"
#' cat(jsonNormalize(jstring, prettify = TRUE))
jsonNormalize <- function(jstring, prettify = FALSE) {
  ctx <- v8()
  ctx$source(system.file("js", "jsonNormalize.js", package = "jsonNormalize"))
  ctx$assign("x", jstring)
  normalize <- paste0(
    c(
      "var normalized = null, error = null;",
      "try {",
      "  normalized = normalize(x);",
      "} catch(err) {",
      "  error = err.message;",
      "}",
      "var result = {normalized: normalized, error: error};"
    ),
    collapse = "\n"
  )
  ctx$eval(normalize)
  result <- ctx$get("result")
  if(!is.null(err <- result[["error"]])) {
    stop("Error while normalizing: ", err)
  }
  jparse <- paste0(
    c(
      "var parsed = null;",
      "try {",
      "  parsed = JSON.parse(result.normalized);",
      "} catch(err) {",
      "  error = err.message;",
      "}",
      "result = {parsed: parsed, error: error};"
    ),
    collapse = "\n"
  )
  ctx$eval(jparse)
  result <- ctx$get("result")
  if(!is.null(err <- result[["error"]])) {
    stop("Error while parsing to JSON: ", err)
  }
  if(prettify) {
    ctx$eval(
      "var pretty = JSON.stringify(result.parsed, null, 2);"
    )
    ctx$get("pretty")
  } else {
    ctx$eval(
      "var mini = JSON.stringify(result.parsed);"
    )
    ctx$get("mini")
  }
}
