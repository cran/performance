test_that("item_difficulty", {
  data(iris)
  x <- iris[, 1:4]
  expect_equal(
    item_difficulty(x, maximum_value = NA), # old behaviour
    structure(
      list(
        Item = c(
          "Sepal.Length", "Sepal.Width", "Petal.Length",
          "Petal.Width"
        ),
        Difficulty = c(0.74, 0.69, 0.54, 0.48),
        Ideal = c(0.56, 0.61, 0.57, 0.7)
      ),
      class = c("item_difficulty", "data.frame"),
      row.names = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
    ),
    tolerance = 1e-3
  )

  out <- item_difficulty(x) # new behaviour
  expect_equal(out$Difficulty, c(0.74, 0.39, 0.48, 0.15), tolerance = 1e-3)
  expect_equal(out$Ideal, c(0.56, 0.56, 0.56, 0.56), tolerance = 1e-3)
})

test_that("item_difficulty, maximum value", {
  x <- data.frame(a = rep(NA, 5), b = 1:5, c = c(1:4, 6))
  out1 <- item_difficulty(x)
  out2 <- item_difficulty(x, maximum_value = 6)
  expect_equal(out1, out2, tolerance = 1e-3, ignore_attr = TRUE)

  out <- item_difficulty(x, maximum_value = 10)
  expect_equal(out$Difficulty, c(NaN, 0.3, 0.32), tolerance = 1e-3, ignore_attr = TRUE)
})

test_that("item_difficulty, maximum value", {
  x <- data.frame(a = rep(NA, 5), b = 1:5, c = c(1:4, 6))
  expect_error(item_difficulty(x, maximum_value = "a"))
})
