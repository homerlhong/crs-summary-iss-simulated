# NAMTSO Phase G0-B01 — Evidence correction and QC gate

Date: 2026-11-12
Status: **NOT RELEASED — static source inspection only**

## Verified in the default branch
- `01_simulate_adam.R`: synthetic ADSL/ADAES/ADCE generator with fixed seed.
- `data/adsl.rds`, `data/adaes.rds`, `data/adce.rds`: committed example data.
- `README.md`: describes a four-stage analysis and independent double-programming QC.

## Blocking discrepancy
The default-branch Git tree at audit time did **not** contain the three scripts listed in README:
- `02_linkage_grouping.R`
- `03_table.R`
- `04_qc_double_program.R`

Therefore **the advertised end-to-end pipeline and independent double-programming QC are NOT VERIFIED**. The presence of synthetic data is not proof that the analysis and QC scripts ran.

## Remediation acceptance criteria
1. Supply the missing scripts or revise README to state accurately that only stage 1 is available.
2. Implement deterministic execution from a clean environment, with pinned dependencies and no confidential data.
3. Add independent QC comparing all cells and denominators; make mismatch produce nonzero exit code.
4. Add CI with a clean run and archive its logs, commit SHA and output hashes.
5. A separate reviewer must inspect the QC implementation and confirm it is independent.
6. Only after these steps may the project be marked REPRODUCED; clinical validation and commercial IP ownership require separate evidence.

## Investor claims policy
Permitted: 'Synthetic CRS data-generation demonstration (source inspected).'
Not permitted: 'Validated end-to-end clinical reporting platform', 'independent QC passed', or 'clinical validation achieved'.

This file documents a gap; it does not claim to fix the missing implementation.
