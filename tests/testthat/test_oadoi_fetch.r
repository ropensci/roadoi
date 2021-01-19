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
  # email
  i <- oadoi_fetch("10.1016/j.aim.2009.06.008", email = "NajkO@GMx.de")
  #paratext
  j <- oadoi_fetch("10.1002/bip.21378", email)
  # flatten
  k <- oadoi_fetch(dois = c("10.1186/s12864-016-2566-9",
                            "10.1103/physreve.88.012814",
                            "10.1093/reseval/rvaa038"), email, .flatten = TRUE)


  # correct classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "tbl_df")
  expect_is(d, "tbl_df")
  expect_is(e, "tbl_df")
  expect_is(f, "tbl_df")
  expect_is(g, "tbl_df")
  expect_is(h, "tbl_df")
  expect_is(i, "tbl_df")
  expect_is(j, "tbl_df")
  expect_is(j, "tbl_df")
  expect_type(k$is_oa, "logical")
  expect_type(k$is_best, "logical")


  # some character matches
  expect_match(h$oa_status, "closed")
  expect_match(h$journal_issn_l, "0001-8708")
  expect_match(a$published_date, "2016-08-09")

  # boolean output
  expect_false(j$is_paratext)



  # correct dimensions
  expect_equal(nrow(a), 1)
  expect_equal(nrow(b), 2)
  expect_equal(nrow(c), 1)
  expect_equal(nrow(d), 2)
  expect_equal(nrow(e), 1)
  expect_equal(nrow(g), 1)
  expect_equal(ncol(e), 20)
  expect_equal(ncol(k), 30)



  # wrong DOI
  expect_warning(oadoi_fetch(dois = c("ldld", "10.1038/ng.3260"), email))
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
