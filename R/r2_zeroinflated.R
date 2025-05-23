#' @title R2 for models with zero-inflation
#' @name r2_zeroinflated
#'
#' @description
#' Calculates R2 for models with zero-inflation component, including mixed
#' effects models.
#'
#' @param model A model.
#'
#' @param method Indicates the method to calculate R2. Can be `"default"` or
#' `"correlation"`. See 'Details'. May be abbreviated.
#'
#' @return For the default-method, a list with the R2 and adjusted R2 values.
#' For `method = "correlation"`, a named numeric vector with the
#' correlation-based R2 value.
#'
#' @details The default-method calculates an R2 value based on the residual
#' variance divided by the total variance. For `method = "correlation"`, R2 is a
#' correlation-based measure, which is rather crude. It simply computes the
#' squared correlation between the model's actual and predicted response.
#'
#' @examples
#' \donttest{
#' if (require("pscl")) {
#'   data(bioChemists)
#'   model <- zeroinfl(
#'     art ~ fem + mar + kid5 + ment | kid5 + phd,
#'     data = bioChemists
#'   )
#'
#'   r2_zeroinflated(model)
#' }
#' }
#' @export
r2_zeroinflated <- function(model, method = "default") {
  method <- insight::validate_argument(method, c("default", "correlation"))

  mi <- insight::model_info(model, verbose = FALSE)
  if (!mi$is_zero_inflated) {
    insight::format_warning("Model has no zero-inflation component.")
  }

  if (method == "default") {
    .r2_zi_default(model)
  } else {
    .r2_zi_correlation(model)
  }
}


.r2_zi_correlation <- function(model) {
  r2_zi <- stats::cor(
    insight::get_response(model, verbose = FALSE),
    stats::predict(model, type = "response")
  )^2
  names(r2_zi) <- "R2 for ZI-models"
  r2_zi
}


.r2_zi_default <- function(model) {
  n <- insight::n_obs(model)
  k <- length(insight::find_parameters(model)[["conditional"]])

  y <- insight::get_response(model, verbose = FALSE)

  var_fixed <- sum((stats::fitted(model) - mean(y))^2)
  var_resid <- sum(stats::residuals(model, type = "pearson")^2)

  r2_zi <- var_fixed / (var_resid + var_fixed)
  r2_zi_adj <- 1 - (1 - r2_zi) * (n - 1) / (n - k - 1)

  out <- list(R2 = r2_zi, R2_adjusted = r2_zi_adj)

  names(out$R2) <- "R2"
  names(out$R2_adjusted) <- "adjusted R2"

  attr(out, "model_type") <- "Zero-Inflated and Hurdle"
  structure(class = "r2_generic", out)
}
