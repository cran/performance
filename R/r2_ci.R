.r2_ci <- function(model, ci = 0.95, verbose = TRUE, ...) {
  alpha <- 1 - ci
  n <- insight::n_obs(model)
  df_int <- if (insight::has_intercept(model)) {
    1
  } else {
    0
  }

  model_rank <- tryCatch(
    model$rank - df_int,
    error = function(e) insight::n_parameters(model) - df_int
  )

  model_r2 <- r2(model, ci = NULL, verbose = verbose, ...)

  out <- lapply(model_r2, function(rsq) {
    ci_low <- stats::uniroot(
      .pRsq,
      c(0.00001, 0.99999),
      R2_obs = as.vector(rsq),
      p = model_rank,
      nobs = n,
      alpha = 1 - alpha / 2
    )$root

    ci_high <- stats::uniroot(
      .pRsq,
      c(0.00001, 0.99999),
      R2_obs = as.vector(rsq),
      p = model_rank,
      nobs = n,
      alpha = alpha / 2
    )$root

    c(rsq, CI_low = ci_low, CI_high = ci_high)
  })

  names(out) <- names(model_r2)
  attr(out, "ci") <- ci
  class(out) <- class(model_r2)
  out
}


.dRsq <- function(K1, R2_pop, R2_obs, p, nobs) {
  NCP <- R2_pop / (1 - R2_pop)
  F1_obs <- ((nobs - p - 1) / p) * (R2_obs / (1 - R2_obs))
  exp(log(
    suppressWarnings(stats::pf(
      q = F1_obs,
      df1 = p,
      df2 = (nobs - p - 1),
      ncp = NCP * K1,
      lower.tail = FALSE
    ))
  ) + stats::dchisq(x = K1, df = (nobs - 1), log = TRUE))
}


.pRsq <- function(R2_pop, R2_obs, p, nobs, alpha = 1) {
  a1 <- 1 - alpha
  # This approach avoids undersampling the area of the chi-squared
  # distribution that actually has any density
  integrals <- mapply(
    function(i, j, ...) {
      dots <- list(...)
      stats::integrate(.dRsq,
        i, j,
        R2_pop = dots$R2_pop,
        R2_obs = dots$R2_obs,
        p = dots$p,
        nobs = dots$nobs
      )
    },
    seq(0, 2, by = 0.25) * nobs,
    c(seq(0.25, 2, by = 0.25), Inf) * nobs,
    MoreArgs = list(
      R2_pop = R2_pop,
      R2_obs = R2_obs,
      p = p,
      nobs = nobs
    ),
    SIMPLIFY = TRUE
  )
  sum(unlist(integrals["value", ])) - a1
}
