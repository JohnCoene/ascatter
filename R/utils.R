.get_dependency <- function(script, path, version, name){
  htmltools::htmlDependency(
    name = name,
    version = version,
    src = system.file(path, package = "ascatter"),
    script = script)
}
