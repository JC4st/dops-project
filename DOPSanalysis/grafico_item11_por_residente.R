
# grafico_item11_por_residente.R

library(dplyr)
library(ggplot2)
library(janitor)

# Función para graficar distribución de 'item_11' por residente
graficar_item11_por_residente <- function(df) {
  df_clean <- df %>%
    filter(!is.na(email), !is.na(item_11)) %>%
    clean_names()

  df_largo <- df_clean %>%
    group_by(email, item_11) %>%
    summarise(n = n(), .groups = "drop") %>%
    group_by(email) %>%
    mutate(prop = n / sum(n)) %>%
    ungroup()

  ggplot(df_largo, aes(x = email, y = prop, fill = item_11)) +
    geom_col(position = "fill") +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      title = "Distribución de respuestas en 'Overall Ability' por residente",
      x = "Residente (email)",
      y = "Proporción (%)",
      fill = "Overall Ability"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Ejecutar si está en modo interactivo
if (interactive()) {
  source("leer_dops.R")
  dops_data <- leer_dops()
  graficar_item11_por_residente(dops_data)
}
