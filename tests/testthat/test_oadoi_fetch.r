context("testing oadoi_fetch")

test_that("oadoi_fetch returns", {
  skip_on_cran()
  email <- "najko.jahn@gmail.com"
  a <- oadoi_fetch(dois = "10.7717/peerj.2323", email)
  b <- oadoi_fetch(dois = c("10.1038/ng.919", "10.1105/tpc.111.088682"),
                   email)
  c <- oadoi_fetch("10.1016/j.shpsc.2013.03.020", email)
  d <- oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                            "10.1016/j.cognition.2014.07.007"),
                   email)
  e <- oadoi_fetch("10.1016/j.vaccine.2014.04.085", email)
  f <- oadoi_fetch(dois = c("10.1016/0898-1221(94)90121-x",
                           "10.1093/ref:odnb/20344"), email)
  g <- oadoi_fetch(dois = c("10.7717/peerj.2323"), email)
  h <- oadoi_fetch("10.1016/j.aim.2009.06.008", email)


  # correct classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "tbl_df")
  expect_is(d, "tbl_df")
  expect_is(e, "tbl_df")
  expect_is(f, "tbl_df")
  expect_is(g, "tbl_df")
  expect_is(h, "tbl_df")

  # some character matches
  expect_match(h$oa_status, "hybrid")
  expect_match(h$journal_issn_l, "0001-8708")



  # correct dimensions
  expect_equal(nrow(a), 1)
  expect_equal(nrow(b), 2)
  expect_equal(nrow(c), 1)
  expect_equal(nrow(d), 2)
  expect_equal(nrow(e), 1)
  expect_equal(nrow(g), 1)
  expect_equal(ncol(e), 18)



  # wrong DOI
  expect_error(oadoi_fetch(dois = c("ldld", "10.1038/ng.3260"), email))
  # wrong .progress value
  expect_warning(oadoi_fetch("10.1038/ng.3260", email, .progress = "TEXT"))
  # empty character
  expect_warning(oadoi_fetch(dois = c("10.7717/peerj.2323", ""), email))
  # missing email address
  expect_error(oadoi_fetch("10.1038/ng.3260", email = NULL))
  # too many dois
  expect_error(oadoi_fetch(rep("10.1016/j.aim.2009.06.008", 200000)))
})

test_that("emails are validated", {
  skip_on_cran()
  expect_error(oadoi_fetch("10.1038/ng.3260", email = 123))
  expect_error(oadoi_fetch("10.1038/ng.3260", email = "najko@gnx"))
  expect_error(oadoi_fetch("10.1038/ng.3260", email = "FOOL"))
})

## lintr
if (requireNamespace("lintr", quietly = TRUE)) {
  context("lints")
  test_that("Package Style", {
    lintr::expect_lint_free()
  })
}
