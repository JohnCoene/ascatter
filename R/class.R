#' ascatter R6 Class
#'
#' Create a VR 3D Scatter Plot.
#'
#' @section Methods:
#' \itemize{
#'   \item{\code{data} Add data.}
#'   \item{\code{build} Build graph.}
#'   \item{\code{get} Get graph.}
#'   \item{\code{browse} Browse graph.}
#'   \item{\code{embed} Embed graph.}
#' }
#'
#' @examples
#'
#' data(population)
#'
#' aScatter$
#'   new(title = "Random")$
#'   data(
#'     population, lon, pop, lat, color, size,
#'     scale = "2 2 2", valfill="1, 9745.6",
#'     yLimit = 0.2, rotation = "0 90 0"
#'   )$
#'   build()$
#'   embed()
#'
#' @export
aScatter <- R6::R6Class(
  "aScatter",
  public = list(
    options = list(),
    initialize = function(...){
      self$options <- list(...)
    },
    data = function(data, x, y, z, size = NULL, color = NULL, ...){

      if(missing(data) || missing(x) || missing(y) || missing(z))
        stop("must pass data, x, y, z", call. = FALSE)

      x <- rlang::enquo(x)
      y <- rlang::enquo(y)
      z <- rlang::enquo(z)
      size <- rlang::enquo(size)
      color <- rlang::enquo(color)
      data <- dplyr::select(data, !!!list(
        x = x, y = y, z = z, size, color
      ))

      data <- apply(data, 1, as.list)
      data <- unname(data)
      data <- jsonlite::toJSON(data, auto_unbox = TRUE, force = TRUE)

      opts <- list(
        raw = paste0(data, collapse = ""),
        x = "x",
        y = "y",
        z = "z",
        ...
      )

      if(!rlang::quo_is_null(size))
        opts$s <- rlang::quo_name(size)

      if(!rlang::quo_is_null(color))
        opts$val <- rlang::quo_name(color)

      private$db <- opts
      invisible(self)
    },
    build = function(...){

      opts <- append(private$db, self$options)

      opts <- glue::glue(
        "{names(private$db)} = '{private$db}'"
      )

      opts <- paste0(opts, collapse = " ")

      tag <- paste0(
        "<a-scatterplot ",
        opts,
        "></a-scatterplot>"
      )

      tag <- htmltools::attachDependencies(
        aframer::a_scene(
          htmltools::HTML(tag),
          aframer::a_dependency(),
          ...
        ),
        list(
          d3_dependency(),
          as_dependency()
        ),
        append = TRUE
      )

      private$plot <- tag
      invisible(self)
    },
    get = function(){
      private$plot
    },
    browse = function(){
      aframer::browse_aframe(private$plot)
    },
    embed = function(width = "100%", height = "400px"){
      style <- glue::glue("width:{width};height:{height};")

      a <- private$plot

      a[[1]] <- htmltools::tagAppendAttributes(a[[1]], style = style, embedded = NA)
      htmltools::div(
        a
      )
    }
  ),
  private = list(
    width = "100%",
    height = "400px",
    plot = NULL,
    db = NULL
  )
)
