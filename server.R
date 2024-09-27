server <- function(input, output) {
  
  datos_normalizados <- reactive({
    datos %>%
      mutate(Pais = case_when(
        Pais == "Peru" ~ "Perú",
        TRUE ~ Pais
      ))
  })
  
  colores_paises <- reactive({
    paises_seleccionados <- input$paises_seleccionados
    colores <- colorFactor(palette = "Set3", domain = paises_seleccionados)  
    colores
  })
  
  datos_filtrados <- reactive({
    datos %>%
      filter(Pais %in% input$paises_seleccionados & 
               Año >= input$rng[1] & Año <= input$rng[2])
  })
  
  poligonos_filtrados <- reactive({
    poligonos %>%
      filter(NAME_ES %in% input$paises_seleccionados)  
  })
  
  output$mapa <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -60.00, lat = -15.00, zoom = 3) %>%
      
      addPolygons(data = poligonos,
                  color = "darkgrey",
                  fillColor = "lightgrey",
                  fillOpacity = 0.2,
                  weight = 1,
                  popup = ~NAME_ES) %>%
      
      addPolygons(data = poligonos_filtrados(),
                  color = ~colores_paises()(NAME_ES),  
                  fillColor = ~colores_paises()(NAME_ES),  
                  fillOpacity = 0.7,
                  weight = 2,
                  popup = ~NAME_ES)
  })
  
  output$grafico_brecha_x <- renderPlot({
    req(input$variable_x)
    
    datos_plot <- datos_filtrados() %>%
      select(Pais, Año, Brecha, all_of(input$variable_x))
    
    datos_plot_long <- datos_plot %>%
      pivot_longer(cols = all_of(input$variable_x), names_to = "Variable_X", values_to = "Valor_X")
    
    ggplot(datos_plot_long, aes(x = Valor_X, y = Brecha, color = Pais)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      facet_wrap(~Variable_X, scales = "free_x") +
      scale_color_manual(values = colores_paises()(input$paises_seleccionados)) +  
      labs(x = "Variables X", y = "Brecha", color = "País") +
      theme_minimal() +
      theme(legend.position = "bottom")
  })
  
  output$boxplot <- renderPlot({
    req(input$boxplot_var)
    
    ggplot(datos_filtrados(), aes(x = Pais, y = .data[[input$boxplot_var]], fill = Pais)) +
      geom_boxplot() +
      scale_fill_manual(values = colores_paises()(input$paises_seleccionados)) +  
      labs(title = paste("Comparación de", input$boxplot_var, "entre países"),
           x = "País",
           y = input$boxplot_var) +
      theme_minimal() +
      theme(legend.position = "none")
  })
}

shinyApp(ui, server)

