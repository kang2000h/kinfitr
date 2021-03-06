context("test-blooddata")

data(pbr28)

blooddata <- create_blooddata_bids(pbr28$jsondata[[5]])

blooddata <- bd_blood_dispcor(blooddata)

blooddata_nocont <- blooddata
blooddata_nocont$Data$Blood$Continuous <- NULL

test_that("creating blooddata from BIDS works", {
  blooddata <- create_blooddata_bids(pbr28$jsondata[[3]])
  expect_true(class(blooddata) == "blooddata")
})


test_that("creating blooddata from vectors works", {
  blooddata2 <- create_blooddata_components(
    Blood.Discrete.Data.Values.sampleStartTime =
      blooddata$Data$Blood$Discrete$Data$Values$sampleStartTime,
    Blood.Discrete.Data.Values.sampleDuration =
      blooddata$Data$Blood$Discrete$Data$Values$sampleDuration,
    Blood.Discrete.Data.Values.activity =
      blooddata$Data$Blood$Discrete$Data$Values$activity,
    Plasma.Data.Values.sampleStartTime =
      blooddata$Data$Plasma$Data$Values$sampleStartTime,
    Plasma.Data.Values.sampleDuration =
      blooddata$Data$Plasma$Data$Values$sampleDuration,
    Plasma.Data.Values.activity =
      blooddata$Data$Plasma$Data$Values$activity,
    Metabolite.Data.Values.sampleStartTime =
      blooddata$Data$Metabolite$Data$Values$sampleStartTime,
    Metabolite.Data.Values.sampleDuration =
      blooddata$Data$Metabolite$Data$Values$sampleDuration,
    Metabolite.Data.Values.parentFraction =
      blooddata$Data$Metabolite$Data$Values$parentFraction,
    Blood.Continuous.Data.Values.time =
      blooddata$Data$Blood$Continuous$Data$Values$time,
    Blood.Continuous.Data.Values.activity =
      blooddata$Data$Blood$Continuous$Data$Values$activity,
    Blood.Continuous.WithdrawalRate =
      blooddata$Data$Blood$Continuous$WithdrawalRate,
    Blood.Continuous.DispersionConstant =
      blooddata$Data$Blood$Continuous$DispersionConstant,
    Blood.Continuous.DispersionConstantUnits =
      blooddata$Data$Blood$Continuous$DispersionConstantUnits,
    Blood.Continuous.DispersionCorrected = FALSE,
    TimeShift = 0
  )
  expect_true(class(blooddata2) == "blooddata")
})

test_that("plotting blooddata works", {
  bdplot <- plot(blooddata)
  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("getting data from blooddata works", {
  blood <- bd_getdata(blooddata, output = "Blood")
  expect_true(any(class(blood) == "tbl"))

  bpr <- bd_getdata(blooddata, output = "BPR")
  expect_true(any(class(bpr) == "tbl"))

  pf <- bd_getdata(blooddata, output = "parentFraction")
  expect_true(any(class(pf) == "tbl"))

  aif <- bd_getdata(blooddata, output = "AIF")
  expect_true(any(class(aif) == "tbl"))

  input <- bd_getdata(blooddata)
  expect_true(any(class(aif) == "tbl"))
})


test_that("addfit works", {
  pf <- bd_getdata(blooddata, output = "parentFraction")
  pf_fit <- metab_hillguo(pf$time, pf$parentFraction)
  blooddata <- bd_addfit(blooddata, fit = pf_fit, modeltype = "parentFraction")

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("addfitted works", {
  pf <- bd_getdata(blooddata, output = "parentFraction")
  pf_fit <- metab_hillguo(pf$time, pf$parentFraction)

  fitted <- tibble::tibble(
    time = seq(min(pf$time), max(pf$time), length.out = 100)
  )
  fitted$pred <- predict(pf_fit, newdata = list(time = fitted$time))

  blooddata <- bd_addfitted(blooddata,
    time = fitted$time,
    predicted = fitted$pred,
    modeltype = "parentFraction"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("addfitpars works", {
  pf <- bd_getdata(blooddata, output = "parentFraction")
  pf_fit <- metab_hillguo(pf$time, pf$parentFraction)

  fitpars <- as.list(coef(pf_fit))

  blooddata <- bd_addfitpars(blooddata,
    modelname = "metab_hillguo_model", fitpars = fitpars,
    modeltype = "parentFraction"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("bloodsplines works", {
  blood <- bd_getdata(blooddata, output = "Blood")
  blood_fit <- blmod_splines(blood$time,
    blood$activity,
    Method = blood$Method
  )

  blooddata <- bd_addfit(blooddata,
    fit = blood_fit,
    modeltype = "Blood"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("starting parameters for expontial when AIF contains zeros works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  aif$aif[100] <- 0
  aif$aif[500] <- 0
  aif$aif[length(aif$aif)] <- -1
  aif$aif[length(aif$aif)-1] <- 0

  start <- blmod_exp_startpars(aif$time,
                               aif$aif,
                               fit_exp3 = T,
                               expdecay_props = c(1/60, 0.1))



  expect_true(any(class(start) == "list"))

})

test_that("exponential works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  blood_fit <- blmod_exp(aif$time,
                             aif$aif,
                             Method = aif$Method,
                             multstart_iter = 1)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("exponential 2exp works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  blood_fit <- blmod_exp(aif$time,
                                 aif$aif,
                                 Method = aif$Method,
                                 multstart_iter = 1, fit_exp3 = F)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})


test_that("exponential peakfitting works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  blood_fit <- blmod_exp(aif$time,
                                 aif$aif,
                                 Method = aif$Method,
                                 multstart_iter = 1,
                                 fit_peaktime = T, fit_peakval = T)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("exponential without method works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  blood_fit <- blmod_exp(aif$time,
                                 aif$aif,
                                 multstart_iter = 1)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("exponential with start parameters works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  startpars <- blmod_exp_startpars(aif$time,
                                   aif$aif)

  blood_fit <- blmod_exp(aif$time,
                         aif$aif,
                         Method = aif$Method,
                         multstart_iter = 1,
                         start = startpars)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("exp_sep works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  blood_fit <- blmod_exp_sep(aif$time,
                                 aif$aif,
                                 Method = aif$Method,
                                 multstart_iter = 1)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})


test_that("exp_sep without method works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  blood_fit <- blmod_exp_sep(aif$time,
                                 aif$aif,
                                 multstart_iter = 1)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})

test_that("exp_sep with start parameters works", {

  aif <- bd_getdata(blooddata, output = "AIF")

  startpars <- blmod_exp_startpars(aif$time,
                                   aif$aif)

  blood_fit <- blmod_exp_sep(aif$time,
                         aif$aif,
                         Method = aif$Method,
                         multstart_iter = 1,
                         start = startpars)

  blooddata <- bd_addfit(blooddata,
                         fit = blood_fit,
                         modeltype = "AIF"
  )

  bdplot <- plot(blooddata)

  expect_true(any(class(bdplot) == "ggplot"))
})


test_that("dispcor with different intervals works", {

  time <- 1:20
  activity <- rnorm(20)
  tau <- 2.5

  time <- time[-c(15, 17, 19)]
  activity <- activity[-c(15, 17, 19)]

  out <- blood_dispcor(time, activity, tau)

  expect_true(nrow(out)==20)
})

test_that("dispcor with different intervals works with orig times", {

  time <- 1:20
  activity <- rnorm(20)
  tau <- 2.5

  time <- time[-c(15, 17, 19)]
  activity <- activity[-c(15, 17, 19)]

  out <- blood_dispcor(time, activity, tau, keep_interpolated = F)

  expect_true(nrow(out)==17)
})

