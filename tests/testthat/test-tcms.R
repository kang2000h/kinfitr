context("test-tcms.R")

data("pbr28")

meas <- 2

tac <- pbr28$tacs[[meas]]$FC
t_tac <- pbr28$tacs[[meas]]$Times / 60
input <- pbr28$input[[meas]]
weights <- pbr28$tacs[[meas]]$Weights
inpshift <- 0.1438066

set.seed(42)

# 1TCM

test_that("1TCM fitting delay works", {
  onetcmout <- onetcm(
    t_tac, tac, input, weights,
    K1.start = 0.1, k2.start = 0.05,
    K1.lower = 0.08, K1.upper = 0.12,
    k2.lower = 0.04, k2.upper = 0.06,
    inpshift.start = 0.15,
    inpshift.lower = 0.14,
    inpshift.upper = 0.16
  )
  expect_lt(onetcmout$par$Vt, 3)
  expect_gt(onetcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(onetcmout)) == "ggplot"))
})

test_that("1TCM with fitted delay works", {
  onetcmout <- onetcm(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.1, k2.start = 0.05,
    K1.lower = 0.08, K1.upper = 0.12,
    k2.lower = 0.04, k2.upper = 0.06
  )
  expect_lt(onetcmout$par$Vt, 3)
  expect_gt(onetcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(onetcmout)) == "ggplot"))
})

test_that("1TCM with frameStartEnd works", {
  onetcmout <- onetcm(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.1, k2.start = 0.05,
    K1.lower = 0.08, K1.upper = 0.12,
    k2.lower = 0.04, k2.upper = 0.06,
    frameStartEnd = c(1, round(0.75 * length(t_tac)))
  )
  expect_lt(onetcmout$par$Vt, 3)
  expect_gt(onetcmout$par$Vt, 1.5)
  expect_lt(max(onetcmout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(onetcmout)) == "ggplot"))
})

test_that("1TCM fitting delay with frameStartEnd works", {
  onetcmout <- onetcm(
    t_tac, tac, input, weights,
    frameStartEnd = c(1, 20)
  )
  expect_lt(onetcmout$par$Vt, 3)
  expect_gt(onetcmout$par$Vt, 1)
  expect_lt(max(onetcmout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(onetcmout)) == "ggplot"))
})

test_that("1TCM fitting delay & multstart works", {
  onetcmout <- onetcm(
    t_tac, tac, input, weights,
    K1.start = 0.1, k2.start = 0.05,
    K1.lower = 0.08, K1.upper = 0.12,
    k2.lower = 0.04, k2.upper = 0.06,
    inpshift.start = 0.15,
    inpshift.lower = 0.14,
    inpshift.upper = 0.16,
    multstart_iter = 2
  )
  expect_lt(onetcmout$par$Vt, 3)
  expect_gt(onetcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(onetcmout)) == "ggplot"))
})

test_that("1TCM with fitted delay & multstart works", {
  onetcmout <- onetcm(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.1, k2.start = 0.05,
    K1.lower = 0.08, K1.upper = 0.12,
    k2.lower = 0.04, k2.upper = 0.06,
    multstart_iter = 2
  )
  expect_lt(onetcmout$par$Vt, 3)
  expect_gt(onetcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(onetcmout)) == "ggplot"))
})


# 2TCM

test_that("2TCM fitting delay works", {
  twotcmout <- twotcm(
    t_tac, tac, input, weights,
    K1.start = 0.11, k2.start = 0.1,
    k3.start = 0.06, k4.start = 0.06,
    K1.lower = 0.06, K1.upper = 0.15,
    k2.lower = 0.06, k2.upper = 0.13,
    k3.lower = 0.03, k3.upper = 0.10,
    k4.lower = 0.03, k4.upper = 0.8,
    inpshift.start = 0.14,
    inpshift.lower = 0.05,
    inpshift.upper = 0.18
  )
  expect_lt(twotcmout$par$Vt, 3)
  expect_gt(twotcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(twotcmout)) == "ggplot"))
})

test_that("2TCM with fitted delay works", {
  twotcmout <- twotcm(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.11, k2.start = 0.1,
    k3.start = 0.06, k4.start = 0.06,
    K1.lower = 0.06, K1.upper = 0.15,
    k2.lower = 0.06, k2.upper = 0.13,
    k3.lower = 0.03, k3.upper = 0.10,
    k4.lower = 0.03, k4.upper = 0.8,
  )
  expect_lt(twotcmout$par$Vt, 3)
  expect_gt(twotcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(twotcmout)) == "ggplot"))
})

test_that("2TCM with frameStartEnd works", {
  twotcmout <- twotcm(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.11, k2.start = 0.1,
    k3.start = 0.06, k4.start = 0.06,
    K1.lower = 0.06, K1.upper = 0.15,
    k2.lower = 0.06, k2.upper = 0.13,
    k3.lower = 0.03, k3.upper = 0.2,
    k4.lower = 0.03, k4.upper = 0.8,
    frameStartEnd = c(1, round(0.9 * length(t_tac)))
  )
  expect_lt(twotcmout$par$Vt, 3)
  expect_gt(twotcmout$par$Vt, 1.5)
  expect_lt(max(twotcmout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(twotcmout)) == "ggplot"))
})

test_that("2TCM fitting delay with frameStartEnd works", {
  twotcmout <- twotcm(
    t_tac, tac, input, weights,
    K1.start = 0.11, k2.start = 0.1,
    k3.start = 0.06, k4.start = 0.06,
    K1.lower = 0.06, K1.upper = 0.15,
    k2.lower = 0.06, k2.upper = 0.2,
    k3.lower = 0.03, k3.upper = 0.2,
    k4.lower = 0.03, k4.upper = 0.8,
    frameStartEnd = c(1, round(0.9 * length(t_tac)))
  )
  expect_lt(twotcmout$par$Vt, 3)
  expect_gt(twotcmout$par$Vt, 1.5)
  expect_lt(max(twotcmout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(twotcmout)) == "ggplot"))
})

test_that("2TCM fitting delay & multstart works", {
  twotcmout <- twotcm(
    t_tac, tac, input, weights,
    K1.start = 0.11, k2.start = 0.1,
    k3.start = 0.06, k4.start = 0.06,
    K1.lower = 0.06, K1.upper = 0.15,
    k2.lower = 0.06, k2.upper = 0.13,
    k3.lower = 0.03, k3.upper = 0.10,
    k4.lower = 0.03, k4.upper = 0.8,
    inpshift.start = 0.14,
    inpshift.lower = 0.05,
    inpshift.upper = 0.18,
    multstart_iter = 2
  )
  expect_lt(twotcmout$par$Vt, 3)
  expect_gt(twotcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(twotcmout)) == "ggplot"))
})

test_that("2TCM with fitted delay & multstart works", {
  twotcmout <- twotcm(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.11, k2.start = 0.1,
    k3.start = 0.06, k4.start = 0.06,
    K1.lower = 0.06, K1.upper = 0.15,
    k2.lower = 0.06, k2.upper = 0.13,
    k3.lower = 0.03, k3.upper = 0.10,
    k4.lower = 0.03, k4.upper = 0.8,
    multstart_iter = 2
  )
  expect_lt(twotcmout$par$Vt, 3)
  expect_gt(twotcmout$par$Vt, 1.5)
  expect_true(any(class(plot_kinfit(twotcmout)) == "ggplot"))
})




# 2TCM1k

test_that("2TCM1k fitting delay works", {
  twotcm1kout <- twotcm1k(
    t_tac, tac, input, weights,
    K1.start = 0.11, k2.start = 0.14,
    k3.start = 0.16, k4.start = 0.13,
    K1.lower = 0.07, K1.upper = 0.20,
    k2.lower = 0.10, k2.upper = 0.30,
    k3.lower = 0.12, k3.upper = 0.30,
    k4.lower = 0.10, k4.upper = 0.20,
    Kb.start = 0.08, Kb.upper = 0.20,
    Kb.lower = 0.1,
    inpshift.start = 0.15,
    inpshift.lower = 0.05,
    inpshift.upper = 0.2
  )
  expect_lt(twotcm1kout$par$Vt, 2)
  expect_gt(twotcm1kout$par$Vt, 1)
  expect_true(any(class(plot_kinfit(twotcm1kout)) == "ggplot"))
})

test_that("2TCM1k with fitted delay works", {
  twotcm1kout <- twotcm1k(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.11, k2.start = 0.14,
    k3.start = 0.16, k4.start = 0.13,
    K1.lower = 0.07, K1.upper = 0.20,
    k2.lower = 0.10, k2.upper = 0.30,
    k3.lower = 0.12, k3.upper = 0.30,
    k4.lower = 0.10, k4.upper = 0.20,
    Kb.start = 0.08, Kb.upper = 0.20,
    Kb.lower = 0.1
  )
  expect_lt(twotcm1kout$par$Vt, 2)
  expect_gt(twotcm1kout$par$Vt, 1)
  expect_true(any(class(plot_kinfit(twotcm1kout)) == "ggplot"))
})

test_that("2TCM1k with frameStartEnd works", {
  twotcm1kout <- twotcm1k(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.11, k2.start = 0.14,
    k3.start = 0.16, k4.start = 0.13,
    K1.lower = 0.07, K1.upper = 0.20,
    k2.lower = 0.05, k2.upper = 0.30,
    k3.lower = 0.12, k3.upper = 0.30,
    k4.lower = 0.05, k4.upper = 0.20,
    Kb.start = 0.08, Kb.upper = 0.12,
    Kb.lower = 0.12,
    frameStartEnd = c(1, round(0.9 * length(t_tac)))
  )
  expect_lt(twotcm1kout$par$Vt, 2)
  expect_gt(twotcm1kout$par$Vt, 1)
  expect_lt(max(twotcm1kout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(twotcm1kout)) == "ggplot"))
})

test_that("2TCM1k fitting delay with frameStartEnd works", {
  twotcm1kout <- twotcm1k(
    t_tac, tac, input, weights,
    K1.start = 0.11, k2.start = 0.14,
    k3.start = 0.16, k4.start = 0.13,
    K1.lower = 0.07, K1.upper = 0.20,
    k2.lower = 0.05, k2.upper = 0.30,
    k3.lower = 0.12, k3.upper = 0.30,
    k4.lower = 0.05, k4.upper = 0.20,
    Kb.start = 0.08, Kb.upper = 0.12,
    Kb.lower = 0.12,
    frameStartEnd = c(1, round(0.9 * length(t_tac)))
  )
  expect_lt(twotcm1kout$par$Vt, 2)
  expect_gt(twotcm1kout$par$Vt, 1)
  expect_lt(max(twotcm1kout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(twotcm1kout)) == "ggplot"))
})

test_that("2TCM1k fitting delay & multstart works", {
  twotcm1kout <- twotcm1k(
    t_tac, tac, input, weights,
    K1.start = 0.11, k2.start = 0.14,
    k3.start = 0.16, k4.start = 0.13,
    K1.lower = 0.09, K1.upper = 0.13,
    k2.lower = 0.12, k2.upper = 0.2,
    k3.lower = 0.14, k3.upper = 0.14,
    k4.lower = 0.12, k4.upper = 0.12,
    Kb.start = 0.12, Kb.upper = 0.12,
    Kb.lower = 0.12,
    inpshift.start = 0.15,
    inpshift.lower = 0.1,
    inpshift.upper = 0.2,
    multstart_iter = 2
  )
  expect_lt(twotcm1kout$par$Vt, 2)
  expect_gt(twotcm1kout$par$Vt, 1)
  expect_true(any(class(plot_kinfit(twotcm1kout)) == "ggplot"))
})

test_that("2TCM1k with fitted delay & multstart works", {
  twotcm1kout <- twotcm1k(
    t_tac, tac, input, weights,
    inpshift = inpshift,
    K1.start = 0.11, k2.start = 0.14,
    k3.start = 0.16, k4.start = 0.13,
    K1.lower = 0.09, K1.upper = 0.13,
    k2.lower = 0.12, k2.upper = 0.16,
    k3.lower = 0.14, k3.upper = 0.18,
    k4.lower = 0.12, k4.upper = 0.14,
    Kb.start = 0.12, Kb.upper = 0.12,
    Kb.lower = 0.12,
    multstart_iter = 2
  )
  expect_lt(twotcm1kout$par$Vt, 2)
  expect_gt(twotcm1kout$par$Vt, 1)
  expect_true(any(class(plot_kinfit(twotcm1kout)) == "ggplot"))
})

# SIME

tacdf <- dplyr::select(pbr28$tacs[[1]], FC:CBL)
Vndgrid <- seq(from = 0, to = 2, by = 0.5)

test_that("SIME works", {
  SIMEout <- SIME(t_tac, tacdf, input, Vndgrid,
    weights = weights,
    inpshift = 0.1, vB = 0.05
  )
  expect_gt(SIMEout$par$Vnd, 0.5)
  expect_lt(SIMEout$par$Vnd, 2)
  expect_true(any(class(plot_kinfit(SIMEout)) == "ggplot"))
})

test_that("SIME with frameStartEnd works", {
  SIMEout <- SIME(t_tac, tacdf, input, Vndgrid,
    weights = weights,
    inpshift = 0.1, vB = 0.05, frameStartEnd = c(1, 33)
  )
  expect_gt(SIMEout$par$Vnd, 0.5)
  expect_lt(SIMEout$par$Vnd, 2)
  expect_lt(max(SIMEout$tacs$Time), max(t_tac))
  expect_true(any(class(plot_kinfit(SIMEout)) == "ggplot"))
})
