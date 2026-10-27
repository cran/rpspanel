## ----include = FALSE----------------------------------------------------------
has_keys <- nzchar(Sys.getenv("EIA_API_KEY")) && nzchar(Sys.getenv("BEA_API_KEY"))
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
options(rpspanel.cache_dir = file.path(tempdir(), "rpspanel-vignette"))

## ----setup--------------------------------------------------------------------
library(rpspanel)

## ----panel, eval = has_keys---------------------------------------------------
# panel <- build_panel(years = 2005:2022)
# panel

## ----vars, eval = has_keys----------------------------------------------------
# small <- build_panel(
#   states = c("CA", "TX", "NY", "IA"),
#   years  = 2010:2022,
#   vars   = c("co2_pc", "re_share_nonhydro", "gdp_real_pc", "rps_nominal")
# )
# head(small)

## ----codebook-----------------------------------------------------------------
head(codebook(), 10)
codebook(group = "rps")

## ----cite---------------------------------------------------------------------
cite_sources(c("eia_seds", "eia_co2", "bea_regional"))

## ----cache--------------------------------------------------------------------
rps_cache_dir()

## ----rps----------------------------------------------------------------------
rps <- build_panel(states = c("CA", "WA", "NC", "TX"), years = 2005:2025,
                   groups = "rps",
                   rps_methods = c("adoption", "nominal", "flexibility"))
rps[rps$year %in% c(2010, 2020), ]

## ----estimate, eval = has_keys && requireNamespace("fixest", quietly = TRUE)----
# library(fixest)
# p <- build_panel(years = 2001:2022, vars = c("co2_pc", "rps_nominal", "gdp_real_pc"))
# feols(log(co2_pc) ~ rps_nominal + log(gdp_real_pc) | state + year,
#       data = as_pdata(p, "fixest"), cluster = ~state)

## ----export-------------------------------------------------------------------
f <- file.path(tempdir(), "rps_panel.dta")
if (requireNamespace("haven", quietly = TRUE)) export_panel(rps, f)

