% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kinfitr_miscfuncs.R
\name{plot_kinfit}
\alias{plot_kinfit}
\title{Plot Kinetic Model Fit: Generic Function}
\usage{
plot_kinfit(modelout, ...)
}
\arguments{
\item{modelout}{The output object of the model fitting procedure.}

\item{...}{Additional optional arguments.}
}
\value{
A ggplot2 object of the plot.
}
\description{
Function to plot the output of a kinetic model. This function calls the specific plotting functions
for each model based on the output of the model.
}
\details{
This function uses the \code{out$model} name to call the correct function to plot the model fit.
}
\examples{

data(pbr28)

t_tac <- pbr28$tacs[[2]]$Times / 60
tac <- pbr28$tacs[[2]]$FC
weights <- pbr28$tacs[[2]]$Weights

input <- blood_interp(
  pbr28$procblood[[2]]$Time / 60, pbr28$procblood[[2]]$Cbl_dispcorr,
  pbr28$procblood[[2]]$Time / 60, pbr28$procblood[[2]]$Cpl_metabcorr,
  t_parentfrac = 1, parentfrac = 1
)

fit <- ma1(t_tac, tac, input, 10, weights)

plot_kinfit(fit, roiname = "FC")
}
\author{
Granville J Matheson, \email{mathesong@gmail.com}
}
