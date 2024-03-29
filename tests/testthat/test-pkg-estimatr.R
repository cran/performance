test_that("Issue #530 from the `modelsummary` repo", {
  skip_if_not_installed("estimatr")
  toy_df <- data.frame(
    y = c(1, 2, 3),
    x = c(1, 2, 4),
    weights = c(0.2, 0.2, 0.6)
  )
  mod <- estimatr::lm_robust(x ~ y, data = toy_df)
  modw <- estimatr::lm_robust(x ~ y, weights = weights, data = toy_df)

  expect_equal(
    as.numeric(r2(mod)$R2),
    summary(mod)$r.squared
  )

  expect_equal(
    as.numeric(r2(modw)$R2),
    summary(modw)$r.squared
  )
})
