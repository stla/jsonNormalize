#' @importFrom rstudioapi getSourceEditorContext setDocumentContents
#' @keywords internal
NormalizeActiveFile <- function() {
  context <- getSourceEditorContext()
  jstring <- paste0(context[["contents"]], collapse = "\n")
  contents <- tryCatch({
    jsonNormalize(jstring, prettify = FALSE)
  }, error = function(e){
    e
  })
  if(inherits(contents, "error")) {
    message("Something went wrong. ", contents$message)
    return(invisible())
  }
  if(!is.null(contents)) setDocumentContents(contents, context[["id"]])
}

#' @importFrom rstudioapi modifyRange
#' @keywords internal
NormalizeActiveSelection <- function() {
  context <- getSourceEditorContext()
  selection <- context[["selection"]][[1L]]
  jstring <- selection[["text"]]
  contents <- tryCatch({
    jsonNormalize(jstring, prettify = FALSE)
  }, error = function(e){
    e
  })
  if(inherits(contents, "error")) {
    message("Something went wrong. ", contents$message)
    return(invisible())
  }
  if(!is.null(contents)) {
    modifyRange(selection[["range"]], contents, context[["id"]])
  }
}

#' @keywords internal
NormalizeAndPrettifyActiveFile <- function() {
  context <- getSourceEditorContext()
  jstring <- paste0(context[["contents"]], collapse = "\n")
  contents <- tryCatch({
    jsonNormalize(jstring, prettify = TRUE)
  }, error = function(e){
    e
  })
  if(inherits(contents, "error")) {
    message("Something went wrong. ", contents$message)
    return(invisible())
  }
  if(!is.null(contents)) setDocumentContents(contents, context[["id"]])
}

#' @keywords internal
NormalizeAndPrettifyActiveSelection <- function() {
  context <- getSourceEditorContext()
  selection <- context[["selection"]][[1L]]
  jstring <- selection[["text"]]
  contents <- tryCatch({
    jsonNormalize(jstring, prettify = TRUE)
  }, error = function(e){
    e
  })
  if(inherits(contents, "error")) {
    message("Something went wrong. ", contents$message)
    return(invisible())
  }
  if(!is.null(contents)) {
    modifyRange(selection[["range"]], contents, context[["id"]])
  }
}
