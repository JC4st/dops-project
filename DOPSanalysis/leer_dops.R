
# leer_dops.R

# Librerías necesarias
library(httr)
library(jsonlite)
library(dplyr)

# Configura tus credenciales de Supabase
URL <- "https://cwpcpdgjncvtghmgwvix.supabase.co"
KEY <- "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN3cGNwZGdqbmN2dGdobWd3dml4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMyODAyMTksImV4cCI6MjA1ODg1NjIxOX0.Vikhe8J17HdSlJQ3e5VdgTsAsrSEHOhTFfhrmqjKt1w"

supabase_url <- URL
supabase_key <- KEY
# También puedes definirlas directamente aquí (menos seguro):
# supabase_url <- "https://tu-proyecto.supabase.co"
# supabase_key <- "tu-api-key"

# Función para obtener datos de la tabla 'dops'
leer_dops <- function() {
  endpoint <- paste0(supabase_url, "/rest/v1/dops?select=*")
  
  res <- GET(
    url = endpoint,
    add_headers(
      apikey = supabase_key,
      Authorization = paste("Bearer", supabase_key)
    )
  )
  
  if (status_code(res) != 200) {
    stop("Error al consultar Supabase: ", status_code(res))
  }
  
  data <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
  return(as_tibble(data))
}

# Ejecutar la función si se corre directamente este archivo
if (interactive()) {
  dops_data <- leer_dops()
  print(glimpse(dops_data))
}
