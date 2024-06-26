test_that("binned_residuals", {
  data(mtcars)
  model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
  result <- binned_residuals(model, ci_type = "gaussian", residuals = "response")
  expect_named(
    result,
    c("xbar", "ybar", "n", "x.lo", "x.hi", "se", "CI_low", "CI_high", "group")
  )
  expect_equal(
    result$xbar,
    c(0.03786, 0.09514, 0.25911, 0.47955, 0.71109, 0.97119),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(-0.03786, -0.09514, 0.07423, -0.07955, 0.28891, -0.13786),
    tolerance = 1e-4
  )
  expect_equal(
    result$CI_low,
    c(-0.05686, -0.12331, -0.35077, -0.57683, 0.17916, -0.44147),
    tolerance = 1e-4
  )
  expect_identical(
    capture.output(print(result)),
    "Warning: Probably bad model fit. Only about 50% of the residuals are inside the error bounds."
  )
})


test_that("binned_residuals, n_bins", {
  data(mtcars)
  model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
  result <- binned_residuals(model, ci_type = "gaussian", residuals = "response", n_bins = 10)
  expect_named(
    result,
    c("xbar", "ybar", "n", "x.lo", "x.hi", "se", "CI_low", "CI_high", "group")
  )
  expect_equal(
    result$xbar,
    c(
      0.02373, 0.06301, 0.08441, 0.17907, 0.29225, 0.44073, 0.54951,
      0.69701, 0.9168, 0.99204
    ),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(
      -0.02373, -0.06301, -0.08441, -0.17907, 0.20775, -0.1074, 0.11715,
      0.30299, -0.25014, 0.00796
    ),
    tolerance = 1e-4
  )
})


test_that("binned_residuals, terms", {
  data(mtcars)
  model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
  result <- binned_residuals(model, ci_type = "gaussian", residuals = "response", term = "mpg")
  expect_named(
    result,
    c("xbar", "ybar", "n", "x.lo", "x.hi", "se", "CI_low", "CI_high", "group")
  )
  expect_equal(
    result$xbar,
    c(12.62, 15.34, 18.1, 20.9, 22.875, 30.06667),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(-0.05435, -0.07866, 0.13925, -0.11861, 0.27763, -0.13786),
    tolerance = 1e-4
  )
})


test_that("binned_residuals, deviance residuals, gaussian CI", {
  data(mtcars)
  model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
  result <- binned_residuals(model, residuals = "deviance", ci_type = "gaussian")
  expect_named(
    result,
    c("xbar", "ybar", "n", "x.lo", "x.hi", "se", "CI_low", "CI_high", "group")
  )
  expect_equal(
    result$xbar,
    c(0.03786, 0.09514, 0.25911, 0.47955, 0.71109, 0.97119),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(-0.26905, -0.44334, 0.03763, -0.19917, 0.81563, -0.23399),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(-0.26905, -0.44334, 0.03763, -0.19917, 0.81563, -0.23399),
    tolerance = 1e-4
  )
  expect_equal(
    result$CI_low,
    c(-0.33985, -0.50865, -0.98255, -1.36025, 0.61749, -1.00913),
    tolerance = 1e-4
  )
})


test_that("binned_residuals, default", {
  data(mtcars)
  model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
  result <- binned_residuals(model)
  expect_named(
    result,
    c("xbar", "ybar", "n", "x.lo", "x.hi", "se", "CI_low", "CI_high", "group")
  )
  expect_equal(
    result$xbar,
    c(0.03786, 0.09514, 0.25911, 0.47955, 0.71109, 0.97119),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(-0.26905, -0.44334, 0.03763, -0.19917, 0.81563, -0.23399),
    tolerance = 1e-4
  )
  expect_equal(
    result$CI_low,
    c(-0.52997, -0.70426, -0.32935, -0.59948, 0.55472, -0.55251),
    tolerance = 1e-4
  )
})


test_that("binned_residuals, bootstrapped CI", {
  skip_on_cran()
  data(mtcars)
  model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
  set.seed(123)
  result <- binned_residuals(model, ci_type = "boot", iterations = 100)
  expect_named(
    result,
    c("xbar", "ybar", "n", "x.lo", "x.hi", "se", "CI_low", "CI_high", "group")
  )
  expect_equal(
    result$xbar,
    c(0.03786, 0.09514, 0.25911, 0.47955, 0.71109, 0.97119),
    tolerance = 1e-4
  )
  expect_equal(
    result$ybar,
    c(-0.26905, -0.44334, 0.03763, -0.19917, 0.81563, -0.23399),
    tolerance = 1e-4
  )
  expect_equal(
    result$CI_low,
    c(-0.32623, -0.50543, -0.80879, -1.15154, 0.67569, -0.65748),
    tolerance = 1e-4
  )
})

test_that("binned_residuals, msg for non-bernoulli", {
  skip_on_cran()
  tot <- rep(10, 100)
  suc <- rbinom(100, prob = 0.9, size = tot)

  dat <- data.frame(tot, suc)
  dat$prop <- suc / tot
  dat$x1 <- as.factor(sample.int(5, 100, replace = TRUE))

  mod <- glm(prop ~ x1,
    family = binomial,
    data = dat,
    weights = tot
  )

  expect_message(binned_residuals(mod), regex = "Using `ci_type = \"gaussian\"`")
  expect_silent(binned_residuals(mod, verbose = FALSE))
})

test_that("binned_residuals, empty bins", {
  eel <- data.frame(
    cured_bin = c(
      1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0,
      0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0,
      0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
      0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0,
      0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1,
      0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0
    ),
    intervention = c(
      "No treatment",
      "No treatment", "No treatment", "No treatment", "Intervention",
      "No treatment", "Intervention", "Intervention", "No treatment",
      "No treatment", "Intervention", "No treatment", "No treatment",
      "Intervention", "No treatment", "No treatment", "Intervention",
      "Intervention", "Intervention", "Intervention", "No treatment",
      "Intervention", "Intervention", "No treatment", "Intervention",
      "Intervention", "No treatment", "No treatment", "Intervention",
      "Intervention", "No treatment", "No treatment", "Intervention",
      "Intervention", "Intervention", "No treatment", "No treatment",
      "Intervention", "No treatment", "Intervention", "No treatment",
      "Intervention", "Intervention", "Intervention", "No treatment",
      "No treatment", "No treatment", "Intervention", "Intervention",
      "No treatment", "Intervention", "Intervention", "Intervention",
      "No treatment", "No treatment", "Intervention", "Intervention",
      "No treatment", "Intervention", "Intervention", "No treatment",
      "No treatment", "No treatment", "Intervention", "Intervention",
      "No treatment", "No treatment", "No treatment", "No treatment",
      "No treatment", "Intervention", "No treatment", "Intervention",
      "Intervention", "Intervention", "No treatment", "Intervention",
      "Intervention", "No treatment", "Intervention", "No treatment",
      "No treatment", "Intervention", "Intervention", "Intervention",
      "Intervention", "No treatment", "Intervention", "Intervention",
      "No treatment", "Intervention", "No treatment", "Intervention",
      "Intervention", "Intervention", "Intervention", "No treatment",
      "No treatment", "No treatment", "Intervention", "No treatment",
      "No treatment", "Intervention", "No treatment", "No treatment",
      "No treatment", "No treatment", "No treatment", "Intervention",
      "Intervention", "No treatment", "No treatment", "Intervention"
    ), duration = c(
      7L, 7L, 6L, 8L, 7L, 6L, 7L, 7L, 8L, 7L, 7L, 7L,
      5L, 9L, 6L, 7L, 8L, 7L, 7L, 9L, 7L, 9L, 8L, 7L, 6L, 8L, 7L, 6L,
      7L, 6L, 7L, 6L, 5L, 6L, 7L, 7L, 8L, 7L, 5L, 7L, 9L, 10L, 7L,
      8L, 5L, 8L, 4L, 7L, 8L, 6L, 6L, 6L, 7L, 7L, 8L, 7L, 7L, 7L, 7L,
      8L, 7L, 9L, 7L, 8L, 8L, 7L, 7L, 7L, 8L, 7L, 8L, 7L, 8L, 8L, 9L,
      7L, 10L, 5L, 7L, 8L, 9L, 5L, 10L, 8L, 7L, 6L, 5L, 6L, 7L, 7L,
      7L, 7L, 7L, 7L, 8L, 5L, 6L, 7L, 6L, 7L, 7L, 9L, 6L, 6L, 7L, 7L,
      6L, 7L, 8L, 9L, 4L, 6L, 9L
    ),
    stringsAsFactors = FALSE
  )
  m_eel <- glm(cured_bin ~ intervention + duration, data = eel, family = binomial())
  out <- binned_residuals(m_eel)
  expect_equal(
    out$xbar,
    c(0.27808, 0.28009, 0.28167, 0.28326, 0.48269, 0.56996, 0.57188, 0.57456),
    tolerance = 1e-4
  )
  expect_equal(
    out$CI_low,
    c(-0.42552, -0.45162, -0.10819, -0.7339, -0.28086, -0.52599, 0.02795, -0.44023),
    tolerance = 1e-4
  )
})
