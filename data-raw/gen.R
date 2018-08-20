url <- "https://ecomfe.github.io/echarts-examples/public/data-gl/asset/data/population.json"

data <- jsonlite::fromJSON(url)

data <- as.data.frame(data)


names(data) <- c("lat", "lon", "pop")
data$color <- data$pop
data$size <- data$pop

population <- data

devtools::use_data(population)
