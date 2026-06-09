# FRAM Publication Strategy

*Flow Response of Antarctic Ice to Meltwater (FRAM) — NSFGEO-NERC: Investigating the Direct Influence of Meltwater on Antarctic Ice Sheet Dynamics*

*Drafted June 2026. A living document — intended as a starting point for team discussion, not a fixed plan. Author roles in particular are placeholders to be agreed by the team.*

---

## 1. Where we stand

Season 1 (Nov 2024 – Jan 2025) deployed GNSS (3 ice sites + rock base station), one unattended ApRES, an AWS, and seismic stations on Flask Glacier, and returned ~2 months of concurrent records. Alongside the field data, the project holds:

| Dataset | Status | Where in this repo |
|---|---|---|
| ApRES vertical strain rates (100–500 m depth) | Season 1 processed; promising signal | `code/apres/season_1/season_1.ipynb` |
| GNSS positions, 3 ice sites | Season 1 processed, uncertainties quantified | `code/gnss/gnss_season_1.ipynb` |
| AWS meteorology | QC'd, archived to zarr (`gs://ldeo-glaciology/aws/flask/`) | `code/aws/season_1.ipynb` |
| WorldView DEMs (4 strips, 2024–25 season) | Coregistered; differenced | `code/WV_dems/coreg_Flask_2425_strips.ipynb` |
| **Proglacial lake drainage** (volume change + imagery sequence) | Quantified; animation produced | `code/WV_dems/lake_volume.ipynb`, `code/WV_images/plot_lake_WV.ipynb` |
| RACMO2.3p2 2 km daily, 1979–2025 (snowmelt, t2m, precip, ff10m) | Full pipeline; subset zarr in cloud | `code/rcm/`, `data/rcm/flask_racmo2km_rechunked.zarr` |
| Satellite velocities (FRAM 200 m time-filtered zarr; continental archive) | Loaded/explored | `Untitled.ipynb`, `gs://ldeo-glaciology/FRAM_velocity/` |
| Larsen C AWS (AWS18/20) regional comparison | Initial integration with RACMO | `code/aws/larsen_AWS.ipynb` |
| Sentinel STAC access, MODIS albedo (GEE), historical TMA imagery | Access infrastructure only | `code/sentinel/`, `code/albedo/`, `code/aerial_imagery/` |

Coming data: **Season 2 (2025–26)** is the pivotal acquisition — recovery of ~1 full year of unattended GNSS, ApRES, and AWS records spanning a complete melt season and winter, plus passive seismics and repeat Wingtra UAS photogrammetry. Site relocation planning for the Oct 2025 recce is in `code/field_planning/midpoint_calc.ipynb`. **Season 3 (2026–27)** extends the record to multi-year.

**Strategy in one sentence:** hold the headline melt–dynamics result for the full annual cycle from Season 2, and publish well-scoped companion papers from data already in hand so the project has output, citations, and established context before the lead paper lands.

---

## 2. Lead paper

### Working title
*Direct observations of the flow response of an Antarctic Peninsula glacier to surface meltwater over a full annual cycle*

### Science question
Does surface meltwater drive transient acceleration of grounded Antarctic Peninsula outlet glaciers — and if so, by what mechanism (basal lubrication vs. enhanced internal deformation), with what magnitude, lag, and seasonal evolution?

Tuckett et al. (2019) inferred melt-driven speedups from satellite velocities; this paper tests that inference directly with the first year-round, co-located, in-situ measurements of melt forcing, surface velocity, and internal deformation on an AP glacier. The mechanism question is what elevates it beyond confirmation: GNSS verticals (uplift / bed separation), ApRES vertical strain (internal deformation partitioning), and seismic tremor (subglacial water flow) discriminate between basal and internal responses in a way satellites cannot.

### Core observational backbone
1. **Melt forcing** — AWS surface energy balance and melt at Flask; RACMO 2 km daily snowmelt for spatial pattern and to rank the observation year against the 1979–2025 climatology (is this a typical, weak, or extreme melt year?).
2. **Flow response** — year-round GNSS velocities at 3+ sites (Season 1 + Season 2), processed with the existing `gnss_season_1.ipynb` workflow; horizontal speedups and vertical uplift during melt events.
3. **Deformation response** — ApRES vertical strain rates (100–500 m), extending the Season 1 pipeline; does the speedup occur with or without a change in internal deformation (i.e., basal sliding)?
4. **Mechanism evidence** — passive seismic record: melt event → subglacial tremor → speedup lag chain.
5. **Spatial/temporal extension** — satellite velocities (FRAM 200 m zarr) to place the in-situ point measurements in the glacier-wide and multi-year context, and as the fallback if winter instrument losses occur.

### Figure plan (~5 main + supplementary)
1. **Setting** — Flask Glacier location, instrument network map, AP melt climatology context (builds on the proposal figure in `code/figures/melt_prediction_figure/` — areas seeing Flask-like melt now vs. end-of-century RCP8.5).
2. **Forcing** — full annual AWS melt/energy time series with RACMO percentile envelope; melt events flagged.
3. **Response** — GNSS horizontal velocity and vertical position at all sites, full year, with zoom panels on individual melt events (and on the lake drainage if it coincides with a dynamic response).
4. **Deformation** — ApRES strain-rate time series against the velocity record; depth-resolved partitioning of the speedup.
5. **Mechanism synthesis** — lag/cross-correlation of melt → seismic tremor power → speedup; schematic of the inferred drainage-system evolution through the season.

### Analyses still needed (gaps as of now)
- Season 2 recovery, QC, and processing (GNSS, ApRES, AWS, seismics) — extend the Season 1 notebooks to year-long records.
- A seismic processing pipeline — none exists in the repo yet; this is the longest-lead-time new development. Decide early whether seismics is in the lead paper or its own paper (§3.4).
- GNSS vertical-component analysis for uplift/bed-separation detection (cf. Doyle et al. 2014 Greenland approach).
- An event-based statistical framework: define melt events, composite the velocity/strain/tremor response, quantify lags and amplitudes with uncertainties.
- RACMO ranking of the 2025–26 melt year within 1979–2025.

### Target journals
1. **Nature Geoscience / Nature Communications** — first in-situ confirmation + mechanism of melt-driven AP dynamics; fits the Tuckett et al. (2019, *Nat. Comms.*) lineage.
2. **Geophysical Research Letters** — fast, high-visibility fallback if the story is clean but compact.
3. **The Cryosphere** — full-length fallback allowing complete methods exposition.

### Authorship (placeholder — for team discussion)
- Lead: project postdocs are the natural candidates (Ben Davison — GNSS/RACMO; Rohi Muthyala — AWS/field lead experience), with Kingslake/Sole/Livingstone/Ely/Winter as senior authors; Hoffman on dynamics interpretation; full field and support team included per contribution. Decide the lead-author split between this paper and the companions early to avoid conflicts.

### Timeline and risks
| Milestone | Target |
|---|---|
| Season 2 recce / redeployment | Oct–Dec 2025 *(done/underway)* |
| Instrument recovery, full-year data in hand | early–mid 2026 |
| Processing + event analysis | mid–late 2026 |
| AGU 2026 presentation (stake the claim) | Dec 2026 |
| Submission | late 2026 – early 2027 |

**Key risk:** unattended instrument failure/loss over winter (power, burial, crevassing). Mitigations: redundancy across the 3+ GNSS sites and 2 ApRES configurations; satellite velocity record as a degraded-mode fallback (the paper survives as "satellite velocities + partial in-situ"); battery analysis already done (`code/apres/battery_usage.ipynb`). **Scooping risk:** other groups working AP dynamics from satellites — mitigate via the conference presence and the companion papers establishing the site.

---

## 3. Companion-paper roadmap

Ordered so each protects, rather than scoops, the lead paper's headline (the in-situ melt→acceleration mechanism result stays out of all of them).

### 3.1 Proglacial lake drainage (data in hand — submit 2025–26)
The Season 1 lake drainage, quantified by differencing coregistered WorldView DEMs (`lake_volume.ipynb`) and documented in the WV imagery sequence (`plot_lake_WV.ipynb`), with melt drivers from AWS + RACMO. A clean, self-contained event paper: drainage volume, rate, trigger, and fate of the water. **Scope guard:** report any coincident velocity signal descriptively at most; the dynamics interpretation belongs to the lead paper. Target: **GRL** or **Journal of Glaciology**. This paper establishes the site and is cited by everything after it.

### 3.2 Flask in the AP melt regime — climatology & context (2026)
RACMO 2 km melt/SMB trends 1979–2025 over the AP, MODIS albedo, Larsen C AWS comparison (`larsen_AWS.ipynb`), Flask AWS validation of RACMO at the site. Answers "why Flask, and how representative is it?" — the contextual foundation the lead paper will lean on. Target: **The Cryosphere**. Natural lead: Davison.

### 3.3 UAS photogrammetry: fine-scale strain and surface evolution (2026–27)
Repeat Wingtra surveys across Seasons 1–3: SfM DEMs and orthomosaics, feature-tracked surface velocity, crevasse-field evolution, validation against satellite velocities and GNSS. Methods-forward contribution on UAS capability for crevassed AP outlet glaciers. Target: **The Cryosphere** or **Annals of Glaciology**. Natural lead: Muthyala.

### 3.4 Subglacial hydrology from passive seismics (2027)
Seasonal evolution of subglacial water flow from tremor; channelization vs. distributed drainage. **Decision point after first-pass Season 2 processing:** if the tremor–speedup chain is strong, fold the headline into the lead paper and make this the detailed methods/seismology follow-up; if marginal, it stands alone. Target: **JGR Earth Surface** or **GRL**.

### 3.5 Three-season synthesis: interannual variability (2027–28)
The capstone: how does the melt–dynamics coupling vary across three melt seasons of different intensity? Extends back in time with the satellite velocity archive and potentially historical TMA imagery (`code/aerial_imagery/`) for multi-decadal change. Target: **Nature Geoscience / Nature Comms** depending on what the lead paper claimed.

### Summary table

| # | Paper | Data dependency | Earliest submission | Journal (1st choice) |
|---|---|---|---|---|
| C1 | Lake drainage | In hand | now – mid 2026 | GRL |
| C2 | AP melt climatology / Flask context | In hand | 2026 | The Cryosphere |
| **L** | **Melt–dynamics annual cycle (lead)** | **Season 2 recovery** | **late 2026 – early 2027** | **Nature Geoscience** |
| C3 | UAS strain & surface evolution | Seasons 1–2 (–3) | 2026–27 | The Cryosphere |
| C4 | Seismic subglacial hydrology | Season 2 | 2027 | JGR Earth Surface |
| C5 | Three-season synthesis | Season 3 | 2027–28 | Nature Geoscience |

---

## 4. Cross-cutting

**Data publication.** NSF and NERC both mandate archiving: USAP-DC (US) and the UK Polar Data Centre, with DOIs minted per dataset and cited in each paper. The existing cloud-zarr infrastructure (`gs://ldeo-glaciology/...`, cryocloud) is the working backbone; plan a one-time effort per paper to snapshot the underlying data + processing notebooks (this repo already keeps them together) into the archive. Publishing the RACMO Flask subset and the QC'd AWS/GNSS/ApRES series as citable datasets also earns data-paper-style citations.

**Conferences.** AGU 2025 (Season 1 + lake drainage), EGU/IGS 2026 (climatology, UAS), AGU 2026 (lead-paper result) — present each result the cycle before its paper submits, to stake claims and gather feedback.

**Sequencing logic.** C1 and C2 go out first: they cost little (data in hand), establish Flask Glacier and the FRAM network in the literature, give the postdocs first-author papers early, and become the setting/forcing citations in the lead paper — without touching the in-situ dynamics result that makes the lead paper novel.

**Internal coordination.** Agree first-author assignments across L, C1–C5 as a team before C1 submits; revisit this document after Season 2 recovery (the C4 fold-in decision, and whether the lead paper's journal ambition should move up or down based on signal quality).

---

## References
- Tuckett, P.A., et al. (2019). Rapid accelerations of Antarctic Peninsula outlet glaciers driven by surface melt. *Nature Communications*, 10, 4311. https://doi.org/10.1038/s41467-019-12039-2
- Trusel, L., et al. (2015). Divergent trajectories of Antarctic surface melt under two twenty-first-century climate scenarios. *Nature Geoscience*, 8, 927–932.
- Doyle, S.H., et al. (2014). Persistent flow acceleration within the interior of the Greenland ice sheet. *Geophysical Research Letters*, 41, 899–905.
- Noël, B., et al. (2023). RACMO2.3p2 2 km surface mass balance product (source of the `code/rcm/` data).
