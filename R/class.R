#' ascatter R6 Class
#'
#' @export
aScatter <- R6::R6Class(
  "aScatter",
  public = list(
    options = list(),
    initialize = function(...){
      self$options <- list(...)
    },
    build = function(data, x, y, z, size = NULL, color = NULL, ...){

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

      private$data <- opts
      invisible(self)
    },
    plot = function(...){

      opts <- append(private$data, self$options)

      opts <- glue::glue(
        "{names(private$data)} = '{private$data}'"
      )

      opts <- paste0(opts, collapse = " ")

      tag <- paste0(
        "<a-scatterplot ",
        opts,
        "></a-scatterplot>"
      )

      htmltools::attachDependencies(
        aframer::a_scene(
          htmltools::HTML(tag),
          ...,
          version = "0.5.0"
        ),
        list(
          d3_dependency(),
          as_dependency()
        ),
        append = TRUE
      )
    }
  ),
  private = list(
    data = NULL
  )
)
