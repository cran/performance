% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_heterogeneity_bias.R
\name{check_heterogeneity_bias}
\alias{check_heterogeneity_bias}
\title{Check model predictor for heterogeneity bias}
\usage{
check_heterogeneity_bias(x, select = NULL, by = NULL, group = NULL)
}
\arguments{
\item{x}{A data frame or a mixed model object.}

\item{select}{Character vector (or formula) with names of variables to select
that should be checked. If \code{x} is a mixed model object, this argument
will be ignored.}

\item{by}{Character vector (or formula) with the name of the variable that
indicates the group- or cluster-ID. If \code{x} is a model object, this
argument will be ignored.}

\item{group}{Deprecated. Use \code{by} instead.}
}
\description{
\code{check_heterogeneity_bias()} checks if model predictors or variables may
cause a heterogeneity bias, i.e. if variables have a within- and/or
between-effect (\emph{Bell and Jones, 2015}).
}
\examples{
\dontshow{if (insight::check_if_installed("datawizard", minimum_version = "0.12.0", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
data(iris)
iris$ID <- sample(1:4, nrow(iris), replace = TRUE) # fake-ID
check_heterogeneity_bias(iris, select = c("Sepal.Length", "Petal.Length"), by = "ID")
\dontshow{\}) # examplesIf}
}
\references{
\itemize{
\item Bell A, Jones K. 2015. Explaining Fixed Effects: Random Effects
Modeling of Time-Series Cross-Sectional and Panel Data. Political Science
Research and Methods, 3(1), 133–153.
}
}
\seealso{
For further details, read the vignette
\url{https://easystats.github.io/parameters/articles/demean.html} and also
see documentation for \code{\link[datawizard:demean]{datawizard::demean()}}.
}
