#' @title Normalize a JSON string
#' @description Attempts to normalize or fix a JSON string. Trailing commas
#'  are removed, and all keys of the normalized JSON string are double-quoted.
#'
#' @param jstring a character string, the JSON string to be normalized, or
#'   the path to a JSON file
#' @param prettify Boolean, whether to prettify the normalized JSON string
#' @param to \code{NULL} to return the normalized JSON string, otherwise
#'   the path to a JSON file to which the normalized JSON string will be
#'   written
#'
#' @return The normalized JSON string.
#' @note The special JavaScript values \code{undefined} and \code{NaN} are not
#'   allowed in JSON strings. If one of them occurs in the input string, it is
#'   replaced by the empty string.
#' @export
#' @import V8
#' @examples
#' library(jsonNormalize)
#' # the keys of the following JSON string are not quoted
#' jstring <- "[{area:30,ind:[5,3.7], cluster:true,},{ind:[],cluster:false},]"
#' cat(jsonNormalize(jstring, prettify = TRUE))
jsonNormalize <- function(jstring, prettify = FALSE, to = NULL) {
  isString <- is.character(jstring) && length(jstring) == 1L && !is.na(jstring)
  if(!isString) {
    stop("`jstring` is not a character string.")
  }
  if(grepl("\\.json$", tolower(jstring))) {
    if(file.exists(jstring)) {
      jstring <- paste0(readLines(jstring), collapse = "\n")
    } else {
      stop(sprintf("File '%s' not found.", jstring))
    }
  }
  if(!is.null(to)) {
    isString <- is.character(to) && length(to) == 1L && !is.na(to)
    if(!isString || !grepl("\\.json$", tolower(to))) {
      stop("`to` is not the name of a JSON file.")
    }
    if(file.exists(to)) {
      stop(sprintf("File '%s' exists and will not be overwritten.", to))
    }
  }
  ctx <- v8()
  ctx$source(system.file("js", "jsonNormalize.js", package = "jsonNormalize"))
  ctx$assign("x", jstring)
  # normalize
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
  # remove trailing commas
  removeTrailingCommas <- paste0(
    c(
      "var nocomma = null;",
      "try {",
      "  eval(`nocomma = ${result.normalized};`);",
      "} catch(err) {",
      "  error = err.message;",
      "}",
      "result = {nocomma: nocomma, error: error};"
    ),
    collapse = "\n"
  )
  ctx$eval(removeTrailingCommas)
  result <- ctx$get("result")
  if(!is.null(err <- result[["error"]])) {
    stop("Error while trying to remove trailing commas: ", err)
  }
  # # JSON parse
  # jparse <- paste0(
  #   c(
  #     "var parsed = null;",
  #     "try {",
  #     "  parsed = JSON.parse(result.nocomma);",
  #     "} catch(err) {",
  #     "  error = err.message;",
  #     "}",
  #     "result = {parsed: parsed, error: error};"
  #   ),
  #   collapse = "\n"
  # )
  # ctx$eval(jparse)
  # result <- ctx$get("result")
  # if(!is.null(err <- result[["error"]])) {
  #   stop("Error while parsing to JSON: ", err)
  # }
  # stringify
  if(prettify) {
    ctx$eval(
      "var output = JSON.stringify(result.nocomma, null, 2);"
    )
  } else {
    ctx$eval(
      "var output = JSON.stringify(result.nocomma);"
    )
  }
  output <- ctx$get("output")
  if(is.null(to)) {
    output
  } else {
    writeLines(output, to)
  }
}
