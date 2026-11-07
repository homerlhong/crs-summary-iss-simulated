# 01_simulate_adam.R
# Fully synthetic ADaM-like data for practising a CRS summary table.
# Mirrors the STRUCTURE of a multi-study ISS (no real data, no real study IDs).
set.seed(20261107)
library(dplyr)

studies <- c("STUDY-A", "STUDY-B", "STUDY-C")   # A uses aerefid1-4 linkage; B/C use aespid
n_per   <- c(120, 60, 40)

# ---- ADSL: one row per subject -------------------------------------------
adsl <- bind_rows(lapply(seq_along(studies), function(i) {
  n <- n_per[i]
  tibble(
    studyid  = studies[i],
    usubjid  = sprintf("%s-%04d", studies[i], seq_len(n)),
    saffl    = sample(c("Y", "N"), n, TRUE, prob = c(.95, .05)),
    tr01ag1n = if (studies[i] == "STUDY-C") 3L else sample(1:2, n, TRUE),
    ipigr1   = sample(c("0-1", "2", "3", "4 - 5"), n, TRUE, prob = c(.2, .3, .3, .2))
  )
}))

# ---- ADAES: CRS events (a subject can have 0..3 CRS episodes) ------------
adaes <- adsl %>%
  filter(saffl == "Y") %>%
  mutate(n_crs = rpois(n(), 0.7)) %>%
  filter(n_crs > 0) %>%
  tidyr::uncount(n_crs, .id = "episode") %>%
  mutate(
    grpnum  = ifelse(studyid == "STUDY-A", as.character(episode), NA),   # link key style 1
    aespid  = ifelse(studyid != "STUDY-A", as.character(episode), NA),   # link key style 2
    aedecod = "CYTOKINE RELEASE SYNDROME",
    trtemfl = "Y", crsfl = "Y",
    atoxgr  = sample(paste("Grade", 1:3), n(), TRUE, prob = c(.65, .3, .05))
  )

# ---- ADCE: CRS signs/symptoms per episode --------------------------------
symptoms <- c("PYREXIA", "HYPOTENSION", "HYPOXIA",          # core three
              "Headache", "Chills", "Tachycardia", "Fatigue", "Nausea", "Other")
adce <- adaes %>%
  rowwise() %>%
  mutate(sym = list(unique(c("PYREXIA",
                             sample(symptoms[-1], sample(0:3, 1)))))) %>%
  ungroup() %>%
  tidyr::unnest(sym) %>%
  transmute(studyid, usubjid,
            ceterm  = sym,
            cedecod = ifelse(sym == "Other", "", toupper(sym)),
            # STUDY-A stores link in aerefid1 (others could be in aerefid2-4)
            aerefid1 = ifelse(studyid == "STUDY-A", grpnum, NA),
            aespid)

dir.create("data", showWarnings = FALSE)
saveRDS(adsl,  "data/adsl.rds")
saveRDS(adaes, "data/adaes.rds")
saveRDS(adce,  "data/adce.rds")
cat("ADSL:", nrow(adsl), " ADAES:", nrow(adaes), " ADCE:", nrow(adce), "\n")
print(head(adce, 6))
