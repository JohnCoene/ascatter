#' Attach dependency
#'
#' Attach scatter plot dependency.
#'
#' @note The package also depends on d3.
#'
#' @examples
#' aframer::a_scene(
#'   aframer::a_sky(),
#'   list(
#'     d3_dependency(),
#'     as_dependency()
#'   )
#' )
#'
#' # OR
#' aframer::a_scene(
#'   aframer::a_sky(),
#'   as_full_dependency()
#' )
#'
#' @rdname dependency
#' @export
as_dependency <- function(){
  .get_dependency("a-scatterplot.min.js", "ascatter", "0.0.1", "ascatter")
}

#' @rdname dependency
#' @export
d3_dependency <- function(){
  .get_dependency("d3.min.js", "d3", "4.4.1", "d3")
}

#' @rdname dependency
#' @export
as_full_dependency <- function(){
  dep <- list()
  dep <- append(dep, d3_dependency())
  dep <- append(dep, as_dependency())
  return(dep)
}
