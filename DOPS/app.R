
library(shiny)
library(httr)
library(jsonlite)

supabase_url <- URL  # Reemplaza con tu URL
supabase_key <- KEY                      # Reemplaza con tu API KEY

ui <- fluidPage(
  titlePanel("Direct Observation of Procedural Skills (DOPS)"),
  sidebarLayout(
    sidebarPanel(
      textInput("doctor_surname", "Trainee surname"),
      textInput("forename", "Forename"),
      textInput("email", "Email (trainee)"),
      checkboxGroupInput("clinical_setting", "Clinical setting", 
                         choices = c("Emergency", "In-patient", "ICU", "Other")),
      textInput("procedure_name", "Procedure Name"),
      checkboxGroupInput("assessor_position", "Assessor's position", 
                         choices = c("Consultant", "GP", "SpR", "SASG", "AHP", "Nurse", "Specialist Nurse", "Other")),
      selectInput("prev_dops", "Previous DOPS observed by assessor",
                  choices = c("0", "1", "2", "3", "4", "5-9", ">9")),
      selectInput("times_performed", "Times procedure performed by trainee",
                  choices = c("0", "1-4", "5-9", ">10")),
      selectInput("procedure_difficulty", "Difficulty of procedure",
                  choices = c("Low", "Average", "High")),
      selectInput("assessor_training", "Training in use of assessment tool?",
                  choices = c("Face-to-Face", "HaveRead Guidelines", "Web"), multiple = TRUE),
      numericInput("obs_time_min", "Time taken for observation (minutes)", value = NA, min = 0),
      numericInput("feedback_time_min", "Time taken for feedback (minutes)", value = NA, min = 0),
      textInput("assessor_surname", "Assessor's Surname"),
      textInput("assessor_email", "Assessor's Email")
    ),
    mainPanel(
      h4("Assessment Criteria"),
      helpText("Select one option per row. U/C = Unable to Comment."),
      uiOutput("assessment_table"),
      textAreaInput("comments", "Comments (strengths or suggestions for development)", "", width = "100%", height = "150px"),
      actionButton("submit", "Submit")
    )
  )
)

server <- function(input, output, session) {
  rubric <- c("Below expectations", "Borderline", "Meets expectations", "Above expectations", "U/C")
  items <- c(
    "Understanding of indications, anatomy, technique",
    "Obtains informed consent",
    "Preparation pre-procedure",
    "Analgesia or safe sedation",
    "Technical ability",
    "Aseptic technique",
    "Seeks help when appropriate",
    "Post-procedure management",
    "Communication skills",
    "Consideration of patient/professionalism",
    "Overall ability"
  )

  output$assessment_table <- renderUI({
    lapply(seq_along(items), function(i) {
      selectInput(paste0("item_", i), paste0(i, ". ", items[i]), choices = rubric)
    })
  })

  observeEvent(input$submit, {
    tryCatch({

      data <- list(
        doctor_surname = input$doctor_surname,
        forename = input$forename,
        email = input$email,
        clinical_setting = paste(input$clinical_setting, collapse = ", "),
        procedure_number = input$procedure_number,
        assessor_position = paste(input$assessor_position, collapse = ", "),
        prev_dops = input$prev_dops,
        times_performed = input$times_performed,
        procedure_difficulty = input$procedure_difficulty,
        assessor_training = paste(input$assessor_training, collapse = ", "),
        obs_time_min = input$obs_time_min,
        feedback_time_min = input$feedback_time_min,
        assessor_surname = input$assessor_surname,
        assessor_email = input$assessor_email,
        comments = input$comments,
        submitted_at = as.character(Sys.time())
      )

      for (i in 1:11) {
        data[[paste0("item_", i)]] <- input[[paste0("item_", i)]]
      }

      res <- POST(
        url = paste0(supabase_url, "/rest/v1/dops"),
        add_headers(
          `apikey` = supabase_key,
          `Authorization` = paste("Bearer", supabase_key),
          `Content-Type` = "application/json",
          `Prefer` = "return=minimal"
        ),
        body = toJSON(data, auto_unbox = TRUE)
      )

      if (status_code(res) == 201) {
      showModal(modalDialog(
        title = "Form submitted",
        "The form was saved successfully.",
        easyClose = TRUE
      ))
      return()

        
    }
    }, error = function(e) {
      showModal(modalDialog(
        title = "Error during submission",
        paste("Error message:", e$message),
        easyClose = TRUE
      ))
    })
  })
}

shinyApp(ui, server)
