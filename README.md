# CRS Summary Table for an Integrated Summary of Safety (Synthetic)

An R implementation of a **cytokine release syndrome (CRS) signs-and-symptoms summary table**, the kind produced for an Integrated Summary of Safety (ISS) of a T-cell–engaging therapy. Every record is **synthetic**. No real patient, sponsor or study data is used.

## Why this table is harder than it looks
- **Cross-study linkage.** Studies store CRS symptoms differently. In one, ADCE links to CRS episodes via `AEREFID1-4 → GRPNUM`; in others it links via `AESPID`. Both are harmonized into a single `LINKID` before any counting.
- **Multi-column grouping.** One subject can contribute to several columns (single study, pooled, and high-risk IPI subsets), so each column has its own denominator.
- **Dummy shells.** Every symptom row appears in every column, with zero-filled counts and fixed ordering (`*** Not coded ***` first).
- **Double-programming QC.** An independent implementation is compared cell by cell.

## Pipeline
| Step | Script | Purpose |
|---|---|---|
| 1 | `01_simulate_adam.R` | Synthetic ADSL / ADAES / ADCE with two linkage styles |
| 2 | `02_linkage_grouping.R` | Harmonize LINKID; derive analysis columns and N |
| 3 | `03_table.R` | Derive "Other" symptoms, apply dummy shell, compute n (%) |
| 4 | `04_qc_double_program.R` | Independent re-derivation and cell-level comparison |

## Run
```bash
Rscript 01_simulate_adam.R
```

## Scope note
This repository demonstrates programming methods only. It contains no proprietary code or data.
