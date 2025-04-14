
# resumen_por_residente.R

library(dplyr)
library(janitor)
library(stringr)

# Esta función toma un data.frame y produce un resumen por residente (email)
resumen_por_residente <- function(df) {
  if (!"email" %in% names(df) || !"item_11" %in% names(df)) {
    stop("El data frame debe contener las columnas 'email' y 'item_11'")
  }

  df_clean <- df %>%
    filter(!is.na(email), !is.na(item_11)) %>%
    clean_names()

  df_grouped <- df_clean %>%
    group_by(email) %>%
    summarise(
      total_dops = n(),
      moda_item_11 = names(sort(table(item_11), decreasing = TRUE))[1],
      distribucion = paste0(
        names(prop.table(table(item_11))) %>%
          sort() %>%
          paste0(": ",
                 round(100 * prop.table(table(item_11))[.], 1), "%"),
        collapse = " | "
      ),
      .groups = "drop"
    )

  return(df_grouped)
}

# Si se ejecuta en un entorno interactivo, muestra un ejemplo con leer_dops()
if (interactive()) {
  source("leer_dops.R")
  dops_data <- leer_dops()
  resumen <- resumen_por_residente(dops_data)
  print(resumen)
}
