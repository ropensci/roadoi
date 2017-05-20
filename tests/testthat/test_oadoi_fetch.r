context("testing oadoi_fetch")

test_that("oadoi_fetch returns", {
  skip_on_cran()
  email <- "test@test.com"
  a <- oadoi_fetch(dois = "10.7717/peerj.2323", email)
  b <- oadoi_fetch(dois = c("10.1038/ng.919", "10.1105/tpc.111.088682"),
                   email)
  c <- oadoi_fetch("10.1016/j.shpsc.2013.03.020", email)
  d <- oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                            "10.1016/j.cognition.2014.07.007"),
                   email)


  # correct classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "tbl_df")
  expect_is(d, "tbl_df")

  # correct dimensions
  expect_equal(nrow(a), 1)
  expect_equal(nrow(b), 2)
  expect_equal(nrow(c), 1)
  expect_equal(nrow(d), 2)

  # wrong DOI
  expect_warning(oadoi_fetch(dois = c("ldld", "10.1038/ng.3260"), email))
  # wrong .progress value
  expect_warning(oadoi_fetch("10.1038/ng.3260", email, .progress = "TEXT"))
  # missing email address
  expect_error(oadoi_fetch("10.1038/ng.3260"))
})

test_that("emails are validated", {
  skip_on_cran()
  expect_error(oadoi_fetch("10.1038/ng.3260", email = 123))
  expect_error(oadoi_fetch("10.1038/ng.3260", email = "najko@gnx"))
  expect_error(oadoi_fetch("10.1038/ng.3260", email = "FOOL"))
})
