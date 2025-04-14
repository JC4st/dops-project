
# leer_dops.R

# Librerías necesarias
library(httr)
library(jsonlite)
library(dplyr)

# Configura tus credenciales de Supabase
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
