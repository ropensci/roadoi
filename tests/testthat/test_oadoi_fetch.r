context("testing oadoi_fetch")

test_that("oadoi_fetch returns", {
  a <- oadoi_fetch(dois = "10.7717/peerj.2323")

  # correct classes
  expect_is(a, "tbl_df")

  expect_warning(oadoi_fetch(dois = c("ldld", "10.1038/ng.3260")))
})
