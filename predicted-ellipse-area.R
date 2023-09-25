## 95% Predicted Ellipse Area calculation for Center of Pressure measurements.

# Authors of original Matlab code: Patric Schubert, Marietta Kirchner (2014)
# Translation from Matlab to R: Tom Vredeveld (2023)

#' Originally, this script was published and written by Patric Schubert and 
#' Marietta Kirchner in 2014, with detailed descriptions in the paper: 
#' "Ellipse area calculations and their applicability in posturography", which
#' can be found here: http://dx.doi.org/10.1016/j.gaitpost.2013.09.001
#' Also, an appendix including Matlab code was uploaded by the authors here: http://dx.doi.org/10.1016/j.gaitpost.2013.09.001 
#' Based on the MATLAB script, I rewrote it to work in the R language. 
#' While trying to rewrite the script, minor adjustments had to be made to be concordant with
#' the script as provided by Schubert and Kirchner. However, I tried to stay close to the original MATLAB version.

#' The function PEA takes 3 arguments,
#' copx and copy timeseries and level of probability, which defaults to 0.95, i.e. 95%.
#' The function returns a list, with 4 elements: 
#' $area (the calculated area of the 95% predicted ellipse),
#' $eigenvalues for the calculation of the area,
#' $eigenvectors for the calculation of the area,  
#' $plot, a ggplot object with CoP data and a ellipse, minor and major axis overlay.


pea <- function(copx, copy, probability = 0.95){
  
  # Set up libraries.
  library(PEIP)
  library(ggplot2)

  # Create list to export calculations to.
  pea <- list(area = NULL, eigenvectors = NULL, eigenvalues = NULL, plot = NULL)
  
  # Calculate inverse of chi-square cumulative distribution function, eigenvalues and area.
  chisquare <- chi2inv(probability, 2) 
  x <- copx[is.finite(copx)]
  y <- copy[is.finite(copy)]
  mx <- mean(x)
  my <- mean(y) 
  vec_val <- eigen(cov(matrix(c(x, y), ncol = 2)))
  val <- matrix(0, nrow = 2, ncol = 2)
  val[1,1] <- vec_val$values[2]
  val[2,2] <- vec_val$values[1] # place values at the right place.
  rotate  <- function(x, clockwise = TRUE) {
    if (clockwise) { t( apply(x, 2, rev))
    } else {apply( t(x),2, rev)} 
  } # Took this function from user: "bud.dugong" @ website: https://stackoverflow.com/questions/16496210/rotate-a-matrix-in-r-by-90-degrees-clockwise
  vec <- rotate(vec_val$vectors, clockwise = FALSE) #rotate to match matlab vectors matrix
  pea$area <- pi * chisquare * prod(sqrt(svd(val)$d))
  pea$eigenvectors <- vec
  pea$eigenvalues <- val
  
  # Create Plot: dataframe
  df_xy <- data.frame(cbind(copx = copx, copy = copy))
  
  # Create Plot: ellipse
  N <- 100 # fixed number, higher creates a smoother ellipse.
  t <- seq(from = 0, to = 2*pi, length.out = N)
  ellipse <- sqrt(chisquare) * vec %*% sqrt(val) %*% 
    t(as.matrix(data.frame(cos_t = cos(t), sin_t = sin(t)))) + 
    kronecker(matrix(1, 1, N), c(mx, my))
  df_ellipse <- data.frame(t(ellipse))
  names(df_ellipse) <- c("x", "y")

  # Create Plot: minor and major axis
  ax1 <- sqrt(chisquare) * vec %*% sqrt(val) %*% as.matrix(rbind(c(-1, 1), c(0, 0))) + kronecker(matrix(1, 1, 2), c(mx, my))
  ax2 <- sqrt(chisquare) * vec %*% sqrt(val) %*% as.matrix(rbind(c(0,0), c(-1, 1))) + kronecker(matrix(1, 1, 2), c(mx, my))
  df_axis <- as.data.frame(rbind(t(ax1), c(NA, NA), t(ax2)))
  names(df_axis) <- c("x", "y")

  # Draw plot using ggplot2
  pea$plot <- ggplot()+
    geom_point(data = df_xy, aes(x = copx, y = copy), colour = "blue", shape = 3)+  #layer 1, data.
    geom_path(data = df_ellipse, aes(x = x, y = y), colour = "red")+                #layer 2, ellipse.
    geom_path(data = df_axis, aes(x = x, y = y), colour = "red")+                   #layer 3, major / minor axis.
    theme_classic()
  
  # Return list with 4 elements.
  return(pea)
} 


