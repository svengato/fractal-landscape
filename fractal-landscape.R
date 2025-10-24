# --------------------------------------------------------------
# Fractal landscape generator, inspired by
# Mandelbrot, "Stochastic Models for the Earth's Relief,
#   the Shape and the Fractal Dimension of the Coastlines, and the Number-Area Rule for Islands",
#   Proc. Nat. Acad. Sci. USA 72 (10), 3825-3828 (1975).
# Mandelbrot, The Fractal Geometry of Nature
# Peitgen, Jürgens, and Saupe, Chaos and Fractals: New Frontiers of Science
#
# Decrease the fractal dimension for smoother landscapes, increase it for more jagged ones.
# --------------------------------------------------------------
library(rgl)
# --------------------------------------------------------------

fractalLandscape <- function(altitudeScale = 4, fractalDimension = 2.5, seed = 42) {
  l <- altitudeScale
  d <- fractalDimension
  # d must be in [2, 3]
  if (d < 2) d <- 2
  else if (d > 3) d <- 3
  f <- 0.5^((3 - d)/2) # scaling factor at each step
  set.seed(seed) # random number seed

  s <- 2^7 # square side length; higher than 128 causes browser artifacts (why?)
  n <- s + 1
  mx.alt <- matrix(NA, nrow = n, ncol = n)
  # Set the corner altitudes
  alt <- rnorm(4, mean = 0, sd = l)
  mx.alt[1, 1] <- alt[1]
  mx.alt[1, n] <- alt[2]
  mx.alt[n, 1] <- alt[3]
  mx.alt[n, n] <- alt[4]

  # ABC
  # DEF
  # GHI
  while (s > 1) {
    # Scale down s and l before step 1
    s <- s %/% 2
    l <- l*f
    # Step 1: set altitudes of midpoints of corners,
    # alt(E) = (alt(A) + alt(C) + alt(G) + alt(I))/4 + rnorm(sd = l)
    i <- s + 1
    while (i <= n) {
      j <- s + 1
      while (j <= n) {
        mx.alt[i, j] <- (mx.alt[i - s, j - s] + mx.alt[i - s, j + s] + mx.alt[i + s, j - s] + mx.alt[i + s, j + s])/4 + rnorm(1, mean = 0, sd = l)
        j <- j + 2*s
      }
      i <- i + 2*s
    }

    # Scale down l before step 2
    l <- l*f
    # Step 2: set altitudes of midpoints of corners and points from step 1
    # first go around the edges, for example
    # alt(B) = (alt(A) + alt(C) + alt(E))/3 + rnorm(sd = l)
    i <- s + 1
    while (i <= n) {
      mx.alt[i, 1] <- (mx.alt[i - s, 1] + mx.alt[i + s, 1] + mx.alt[i, 1 + s])/3 + rnorm(1, mean = 0, sd = l)
      mx.alt[i, n] <- (mx.alt[i - s, n] + mx.alt[i + s, n] + mx.alt[i, n - s])/3 + rnorm(1, mean = 0, sd = l)
      i <- i + 2*s
    }
    j <- s + 1
    while (j <= n) {
      mx.alt[1, j] <- (mx.alt[1, j - s] + mx.alt[1, j + s] + mx.alt[1 + s, j])/3 + rnorm(1, mean = 0, sd = l)
      mx.alt[n, j] <- (mx.alt[n, j - s] + mx.alt[n, j + s] + mx.alt[n - s, j])/3 + rnorm(1, mean = 0, sd = l)
      j <- j + 2*s
    }
    # then fill in the bulk,
    # alt(E) = (alt(A) + alt(C) + alt(G) + alt(I))/4 + rnorm(sd = l)
    i <- s + 1
    while (i < n) {
      j <- 2*s + 1
      while (j < n) {
        mx.alt[i, j] <- (mx.alt[i - s, j] + mx.alt[i + s, j] + mx.alt[i, j - s] + mx.alt[i, j + s])/4 + rnorm(1, mean = 0, sd = l)
        j <- j + 2*s
      }
      i <- i + 2*s
    }
    j <- s + 1
    while (j < n) {
      i <- 2*s + 1
      while (i < n) {
        mx.alt[i, j] <- (mx.alt[i - s, j] + mx.alt[i + s, j] + mx.alt[i, j - s] + mx.alt[i, j + s])/4 + rnorm(1, mean = 0, sd = l)
        i <- i + 2*s
      }
      j <- j + 2*s
    }
  }

  mx.alt
}

plotFractalLandscape <- function(mx.alt, displayWater = TRUE) {
  # terrain color scheme
  ntc <- 8
  tc <- terrain.colors(ntc)

  # to display water, set negative altitudes to zero
  if (displayWater) {
    zmin <- 0
    mx.alt[mx.alt < zmin] <- zmin
    waterColor <- "blue"
    tc <- c(waterColor, tc)
  } else {
    tc <- c(tc[1], tc)
  }

  diffAlt <- diff(range(mx.alt))
  minAlt <- min(mx.alt)
  zColor <- tc[ceiling(ntc*(mx.alt - minAlt)/diffAlt) + 1]

  clear3d()
  surface3d(1:nrow(mx.alt), 1:ncol(mx.alt), mx.alt, color = zColor)
}

# --------------------------------------------------------------

# Example usage
# plotFractalLandscape(fractalLandscape())
# plotFractalLandscape(fractalLandscape(), displayWater = FALSE)

# --------------------------------------------------------------
