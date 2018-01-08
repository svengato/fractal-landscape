source("fractal-landscape.R", local = TRUE)

# Define the server logic
shinyServer(function(input, output) {
  output$plotFL <- renderRglwidget({
    mx.alt <- fractalLandscape(altitudeScale = input$sldAlt, fractalDimension = input$sldDim,
      seed = input$spnSeed)
    plotFractalLandscape(mx.alt, displayWater = input$chkWater)
    rglwidget()
  })
})
