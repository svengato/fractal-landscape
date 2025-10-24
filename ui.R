# --------------------------------------------------------------
library(shiny)
options(rgl.useNULL = TRUE)
library(rgl)
# --------------------------------------------------------------

# Define the user interface
shinyUI(fluidPage(
  titlePanel("Fractal Landscape"),

  p(HTML(paste("Fractal landscape generator, inspired by",
    "<br>&bull; Mandelbrot, <i>Stochastic Models for the Earth&rsquo;s Relief,",
    "the Shape and the Fractal Dimension of the Coastlines,",
    "and the Number-Area Rule for Islands</i>,",
    "Proc. Nat. Acad. Sci. USA 72 (10), 3825-3828 (1975).",
    "<br>&bull; Mandelbrot, <i>The Fractal Geometry of Nature</i>",
    "<br>&bull; Peitgen, J&uuml;rgens, and Saupe, <i>Chaos and Fractals: New Frontiers of Science</i>"
  ))),
  p("Decrease the fractal dimension for smoother landscapes, increase it for more jagged ones."),

  sidebarPanel(
    sliderInput("sldAlt", label = "Altitude Scale", min = 1, max = 8, value = 4),
    sliderInput("sldDim", label = "Dimension", min = 2, max = 3, step = 0.1, value = 2.5),
    numericInput("spnSeed", label = "Seed", min = 1, max = 100000, value = 42, width = 100),
    checkboxInput("chkWater", label = "Show Water", value = TRUE),
    conditionalPanel("input.chkWater == true", sliderInput("waterLevel", label = "Water Level", min = -10, max = 10, step = 1, value = 0))
  ),

  mainPanel(
    style = "width: 522px; border: 1px solid lightgray; padding: 4px",
    p("If you do not see the landscape, click and drag or zoom within this panel."),
    rglwidgetOutput("plotFL")
  )
))

# --------------------------------------------------------------
