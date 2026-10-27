## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", fig.width = 7, fig.height = 4)
has_keys <- nzchar(Sys.getenv("EIA_API_KEY")) && nzchar(Sys.getenv("BEA_API_KEY"))

## ----setup--------------------------------------------------------------------
library(rpspanel)

## ----rules--------------------------------------------------------------------
rules <- rps_rules()
rules
head(rules$targets)

## ----stringency---------------------------------------------------------------
s <- rps_stringency(2000:2030, states = c("CA", "OR", "WA", "NC", "MA"))
head(s[s$state == "OR", ], 15)

## ----interp-------------------------------------------------------------------
lin  <- rps_stringency(2010:2022, "WA", method = "nominal")
step <- rps_stringency(2010:2022, "WA", method = "nominal", interpolation = "step")
plot(lin$year, lin$rps_nominal, type = "l", ylab = "Required share", xlab = "",
     main = "Washington RPS")
lines(step$year, step$rps_nominal, type = "s", lty = 2)
legend("topleft", c("linear", "step"), lty = 1:2, bty = "n")

## ----nominal-plot-------------------------------------------------------------
cols <- c(CA = "#1b9e77", OR = "#d95f02", WA = "#7570b3", NC = "#e7298a", MA = "#66a61e")
plot(NA, xlim = c(2000, 2030), ylim = c(0, 0.65), xlab = "",
     ylab = "Nominal requirement (share of sales)")
for (st in names(cols)) {
  d <- s[s$state == st, ]
  lines(d$year, d$rps_nominal, col = cols[st], lwd = 2)
}
legend("topleft", names(cols), col = cols, lwd = 2, bty = "n")

## ----incremental--------------------------------------------------------------
base <- data.frame(state = c("CA", "OR"), baseline_share = c(0.11, 0.03))
inc <- rps_stringency(c(2010, 2020, 2030), c("CA", "OR"),
                      method = c("coverage_adjusted", "incremental"),
                      baseline = base)
inc

## ----capacity-----------------------------------------------------------------
tx_sales <- data.frame(state = "TX", year = c(2010, 2015), sales_gwh = c(358000, 380000))
rps_stringency(c(2010, 2015), "TX", method = "nominal", sales = tx_sales)
rps_stringency(c(2010, 2015), "TX", method = "nominal", sales = tx_sales,
               capacity_factor = 0.4)

## ----yp, eval = FALSE---------------------------------------------------------
# library(fixest)
# p <- build_panel(years = 2001:2022,
#                  vars = c("re_share_nonhydro", "rps_incremental", "rps_adoption",
#                           "gdp_real_pc", "elec_price_real"))
# feols(re_share_nonhydro ~ rps_incremental + log(gdp_real_pc) + elec_price_real |
#         state + year,
#       data = as_pdata(p, "fixest"), cluster = ~state)

