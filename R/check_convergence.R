#' @title Convergence test for mixed effects models
#' @name check_convergence
#'
#' @description `check_convergence()` provides an alternative convergence
#'   test for `merMod`-objects.
#'
#' @param x A `merMod` or `glmmTMB`-object.
#' @param tolerance Indicates up to which value the convergence result is
#'   accepted. The smaller `tolerance` is, the stricter the test will be.
#' @param ... Currently not used.
#'
#' @return `TRUE` if convergence is fine and `FALSE` if convergence
#'   is suspicious. Additionally, the convergence value is returned as attribute.
#'
#' @section Convergence and log-likelihood:
#' Convergence problems typically arise when the model hasn't converged
#' to a solution where the log-likelihood has a true maximum. This may result
#' in unreliable and overly complex (or non-estimable) estimates and standard
#' errors.
#'
#' @section Inspect model convergence:
#' **lme4** performs a convergence-check (see `?lme4::convergence`),
#' however, as as discussed [here](https://github.com/lme4/lme4/issues/120)
#' and suggested by one of the lme4-authors in
#' [this comment](https://github.com/lme4/lme4/issues/120#issuecomment-39920269),
#' this check can be too strict. `check_convergence()` thus provides an
#' alternative convergence test for `merMod`-objects.
#'
#' @section Resolving convergence issues:
#' Convergence issues are not easy to diagnose. The help page on
#' `?lme4::convergence` provides most of the current advice about
#' how to resolve convergence issues. Another clue might be large parameter
#' values, e.g. estimates (on the scale of the linear predictor) larger than
#' 10 in (non-identity link) generalized linear model *might* indicate
#' [complete separation](https://stats.oarc.ucla.edu/other/mult-pkg/faq/general/faqwhat-is-complete-or-quasi-complete-separation-in-logisticprobit-regression-and-how-do-we-deal-with-them/).
#' Complete separation can be addressed by regularization, e.g. penalized
#' regression or Bayesian regression with appropriate priors on the fixed effects.
#'
#' @section Convergence versus Singularity:
#' Note the different meaning between singularity and convergence: singularity
#' indicates an issue with the "true" best estimate, i.e. whether the maximum
#' likelihood estimation for the variance-covariance matrix of the random effects
#' is positive definite or only semi-definite. Convergence is a question of
#' whether we can assume that the numerical optimization has worked correctly
#' or not.
#'
#' @family functions to check model assumptions and and assess model quality
#'
#' @examplesIf require("lme4") && require("glmmTMB")
#' data(cbpp, package = "lme4")
#' set.seed(1)
#' cbpp$x <- rnorm(nrow(cbpp))
#' cbpp$x2 <- runif(nrow(cbpp))
#'
#' model <- lme4::glmer(
#'   cbind(incidence, size - incidence) ~ period + x + x2 + (1 + x | herd),
#'   data = cbpp,
#'   family = binomial()
#' )
#'
#' check_convergence(model)
#'
#' \donttest{
#' model <- suppressWarnings(glmmTMB::glmmTMB(
#'   Sepal.Length ~ poly(Petal.Width, 4) * poly(Petal.Length, 4) +
#'     (1 + poly(Petal.Width, 4) | Species),
#'   data = iris
#' ))
#' check_convergence(model)
#' }
#' @export
check_convergence <- function(x, tolerance = 0.001, ...) {
  insight::is_converged(x, tolerance = tolerance, ...)
}
