# Northwind Data Warehouse Project

Welcome to the **Northwind Data Warehouse Project** repository!  

---
## Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is created with SQL script from Microsoft Sample Databases.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

![architecture]([https://github.com/mrvneslihan/northwind-data-warehouse-project/blob/main/architecture.png])

---

## Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.

---

## 📂 Repository Structure
```
northwind-data-warehouse-project/
│
├── datasets/                           # Script for creating dataset
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── README.md                           # Project overview and instructions
└── LICENSE                             # License information for the repository
```
---

## Contact Information

For any questions, suggestions, or feedback, feel free to reach out:

- **Email:** merveneslihan08@gmail.com
- **LinkedIn:** [My LinkedIn Profile](www.linkedin.com/in/merveneslihanokcu)
- **GitHub:** [My GitHub Profile](https://github.com/mrvneslihan)

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.
