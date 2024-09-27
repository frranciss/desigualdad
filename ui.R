ui <- dashboardPage(
  title = "Desigualdad", 
  skin = "blue",
  
  dashboardHeader(title = "Desigualdad"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visualizaciones", tabName = "mapa_tab", icon = icon("globe-americas"))  # Solo una pestaña
    ),
    selectInput("paises_seleccionados", 
                label = "Seleccionar país(es)", 
                choices = paises, 
                selected = paises[1], 
                multiple = TRUE),
    sliderInput("rng", "Años", value = c(1995, 2021), min = 1995, max = 2021),
    selectInput("variable_x", 
                label = "Seleccionar Variables X:", 
                choices = variables_x, 
                selected = variables_x[1],
                multiple = TRUE),
    selectInput("boxplot_var", "Variable para Boxplot:", 
                choices = variables_x, selected = variables_x[1])
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "mapa_tab",  
              fluidRow(
                column(width = 6,
                       box(title = "Mapa de América Latina", width = NULL,
                           leafletOutput("mapa", height = 400))),
                column(width = 6,
                       box(title = "Boxplot Comparativo", width = NULL,
                           plotOutput("boxplot", height = 400)))         
              ),
              fluidRow(
                column(width = 12,
                       box(title = "Gráfico de Brecha vs Variable X", width = NULL,
                           plotOutput("grafico_brecha_x", height = 300)))
              )
      )
    )
  )
)
