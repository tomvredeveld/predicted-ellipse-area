# predicted-ellipse-area
Calculation of the 95% Predicted Ellipse Area in R from center of pressure (COP) measurements by means of posturography, following the code as published by Dr. P Schubert and Dr. M. Kirschner. The COP is the resultant of ground reaction forces and is frequently depicted as medio-lateral and anterior-posterior movements, often measured using a force plate, e.g. AMTI, Kistler, Wii Balance Board. A 95% Predicted Ellipse Area may be used to evaluate COP scatter and therefore help to quantify postural sway while maintaining a certain position. 

## Introduction 
This repository is a fairly simple and straightforward one. It contains a single `R` file with the code to create a 95% Predicted Ellipse Area, as described by dr. P. Schubert and dr. M. Kirchner in 2014 in the paper [Ellipse area calculations and their applicability in posturography.](https://doi.org/10.1016/j.gaitpost.2013.09.001) as published in Gait & Posture, 2014, 39, 1: page 558-522.  
The `R-script` is merely a 'translation' of the Matlab code supplied with the [appendix](https://ars.els-cdn.com/content/image/1-s2.0-S0966636213005961-mmc1.docx) of the article, therefore all credits belong to the original authors as mentioned before. 

## How it works
The script uses two packages: `PEIP` and `ggplot2` which can be found [here](URL) and [here](url) on CRAN respectively and need to be installed beforehand. 

The script contains the function `pea()`which takes three arguments: a vector `copx` which denotes the movement of the COP on the medio-lateral axis, a vector `copy` for the movement of the COP on the anterior-posterior axis and `probability`, a single value between 0 and 1.00 to indicate the probability ellipse, which defaults at 95%. 

The function `pea()` returns a list with four arguments, which are equal to the results of the original Matlab script. These include: `$area`which contains the area, `$eigenvectors` calculated eigenvectors of the data, `$eigenvalues` eigenvalues of the copx and copy data and `$plot` using the `ggplot2` package. 

## Suggestions, errors or contributions? 
Feel free to send me an e-mail at t.vredeveld (at) hva (dot) nl, make a pull-request or create an issue. 
