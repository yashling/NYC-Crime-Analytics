# 🔄 NYC Crime Analytics: End-to-End Data Pipeline

This project demonstrates a **cloud-native analytics pipeline** that transforms raw crime complaint records from **New York City** into an interactive, insight-rich dashboard. Built using **Google BigQuery** for data ingestion and transformation, and **Looker Studio** for visualization, the pipeline enables scalable and automated reporting for public safety insights.

---

## 📦 Project Highlights

- ✅ Fully serverless and automated — no manual data handling
- ✅ Cleansed, enriched, and transformed 1M+ records
- ✅ Powers a 3-page interactive dashboard in Looker Studio
- ✅ Supports strategic planning for law enforcement and city planners

---

## 📥 1. Data Ingestion — From API to BigQuery

Raw crime data is fetched directly from the [NYC Open Data API](https://data.cityofnewyork.us/resource/qb7u-rbmr.csv) and loaded into **Google BigQuery**.

### 🔧 Tools Used
- `requests` or scheduled BigQuery Data Transfer
- Google Cloud Storage (optional staging)
- BigQuery native ingestion

### ⚙️ Benefits
- Real-time data availability
- No need for manual CSV downloads
- Scalable and repeatable for long-term usage

---

## 🧹 2. Data Preprocessing — Cleansing & Feature Engineering in BigQuery

Using **SQL transformations in BigQuery**, the raw data was prepared for analytical use. Below are the major transformation steps:

### ✅ A. Data Cleaning

| Field | Transformation |
|-------|----------------|
| `vic_sex`, `susp_sex`, `vic_age_group`, `susp_age_group`, `vic_race` | Null/invalid/garbage values removed |
| Latitude/Longitude | Invalid/missing coordinates removed |
| Categorical Fields | Mapped inconsistent/case-sensitive values |

---

### 🧠 B. Feature Engineering (Calculated Fields)

| Field Name | Description |
|------------|-------------|
| `year`, `month`, `weekday`, `hour` | Extracted from `cmplnt_fr_dt` and `cmplnt_fr_tm` |
| `time_of_day` | Binned hours into segments (e.g., Morning, Evening) |
| `lat_lon` | Combined coordinates into string for mapping |
| `crime_status` | Mapped `crm_atpt_cptd_cd` to “Attempted” or “Completed” |
| `law_severity` | Standardized `law_cat_cd` to Felony, Misdemeanor, Violation |
| `relationship_type` | Derived from `prem_typ_desc` (e.g., Domestic, Stranger) |
| `clean_vic_sex`, `clean_susp_sex` | Mapped gender codes (M/F/U) to readable labels |
| `clean_vic_age_group`, `clean_susp_age_group` | Bucketed age groups into: `<18`, `18–24`, `25–44`, `45–64`, `65+` |
| `repeat_offender_flag` | Flag for suspects aged 25–44 |
| `elderly_victim_flag` | Flag for victims aged 65+ |

All transformations were modularized using `CASE` statements to support filters, scorecards, and drill-down charts in Looker.

---

## 📊 3. Visualization — Interactive Looker Studio Dashboard

The final, cleaned dataset feeds into a **3-page dashboard** built in Looker Studio for public exploration and strategic planning.

### 📌 Dashboard Sections

1. **📈 Time Trends**
   - Crime frequency by year, month, weekday, and hour

2. **👤 Demographics**
   - Victim vs. suspect breakdowns by gender, age group, and race

3. **🗺️ Geospatial Analysis**
   - Borough-wise heatmaps
   - Latitude/Longitude clusters

4. **🚇 Transit Safety**
   - Crimes near transit stops by time of day

5. **⚖️ Crime Severity**
   - Felony, misdemeanor, and violation analysis by area and type

---

## 🔗 Links

- **🧪 Looker Studio Dashboard**  
  👉 [View Live Dashboard](https://lookerstudio.google.com/reporting/851067c9-4604-4af0-8b9c-b0bea9d62a33)

- **📄 NYC Open Data API (CSV)**  
  👉 [API Link](https://data.cityofnewyork.us/resource/qb7u-rbmr.csv)

---

## 🛠️ Tech Stack

| Tool | Role |
|------|------|
| Google BigQuery | Cloud data warehouse & SQL engine |
| Looker Studio | Dashboarding & visualization |
| NYC Open Data API | Crime complaint data source |
| SQL | Data transformation & feature engineering |

---

## ✅ Next Steps

- Automate ingestion via Cloud Scheduler & Cloud Functions
- Add user filters by borough, severity, and age group
- Integrate population data for crime rate normalization

---

## 📄 License

MIT License

---

## 🙌 Contributions

Feel free to fork, contribute, or raise issues. Collaboration is welcome!
