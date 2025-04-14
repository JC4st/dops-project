
# analizar_dops.R

# Paquetes necesarios
library(httr)
library(jsonlite)
library(dplyr)
library(readr)

# Supabase config
supabase_url <- SUPABASE_URL
supabase_key <- SUPABASE_KEY

# Función para obtener datos de la tabla 'dops'
leer_dops <- function() {
  res <- GET(
    paste0(supabase_url, "/rest/v1/dops?select=*"),
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

# Función para análisis básico
analizar_dops <- function(df) {
  df %>%
    count(item_11) %>%
    mutate(prop = round(n / sum(n) * 100, 1)) %>%
    arrange(desc(prop))
}

# Función para exportar a CSV
exportar_dops <- function(df, archivo = "dops_export.csv") {
  write_csv(df, archivo)
  message("Archivo exportado a: ", archivo)
}

# Ejecución
if (interactive()) {
  dops_data <- leer_dops()
  print("Vista general de los datos:")
  print(glimpse(dops_data))

  resumen <- analizar_dops(dops_data)
  print("Resumen de Overall Ability (item_11):")
  print(resumen)

  exportar_dops(dops_data)
}
