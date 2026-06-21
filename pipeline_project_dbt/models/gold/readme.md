Gold Layer
==========

Overview
--------

This folder contains the models responsible for building the **Gold layer** of the **Medallion Architecture**. The Gold layer is the analytics-ready stage where cleansed and enriched Silver data is combined with dimension state to produce business-facing fact tables and reporting datasets.

The primary objective of the Gold layer is to prepare data for analytics, dashboards, and downstream consumption by joining enriched entities and applying business-level relationships.

Data Processing & Transformations
---------------------------------

The Gold layer performs the following operations:

*   **Entity consolidation**
    *   Joining Silver model outputs into a unified business table.
    *   Combining bookings, listings, and host information for analytics.
*   **Fact generation**
    *   Building a fact-level dataset for reporting and metrics.
    *   Producing a single point of access for analytical queries.
*   **Snapshot consumption**
    *   Joining with snapshot dimension tables to capture slowly changing state.
    *   Preserving historical context for dimensional attributes.
*   **Business logic application**
    *   Aligning relationships across entities using business keys.
    *   Ensuring fact rows reflect the latest valid dimension values.

Primary Models
--------------

*   `one_big_table.sql`
    *   Consolidates Silver layer outputs into a single business-ready table.
    *   Joins `silver_bookings`, `silver_listings`, and `silver_hosts`.
    *   Exposes the primary analytics columns used by downstream Gold models.
*   `fact.sql`
    *   Builds the Gold fact dataset used for reporting.
    *   Joins `one_big_table` with snapshot dimensions: `dim_bookings`, `dim_hosts`, and `dim_listings`.
    *   Ensures the fact model references persisted dimension state in the `AIRBNB.GOLD` schema.

Snapshot Relationships
----------------------

The Gold layer depends on snapshot tables for slowly changing dimensions:

*   `dim_bookings` — preserves booking history and updated booking metadata.
*   `dim_hosts` — preserves evolving host attributes and response quality.
*   `dim_listings` — preserves listing details, pricing state, and property attributes.

Because these are dbt snapshots, they must be created with `dbt snapshot` before the Gold fact model is built.

Model Behavior
--------------

### `one_big_table.sql`

This model is responsible for:

*   Joining the Silver bookings, hosts, and listings datasets.
*   Creating a consolidated table with booking, host, and listing details.
*   Selecting analytics-ready columns like `TOTAL_AMOUNT`, `RESPONSE_RATE`, and `PRICE_PER_NIGHT`.

### `fact.sql`

This model is responsible for:

*   Using `one_big_table` as the central fact input.
*   Joining with snapshot dimensions using business keys such as `listing_id` and `host_id`.
*   Producing a fact-level dataset suitable for dashboards and analysis.

Design Principles
-----------------

*   **Business-Ready Output:** Data in this layer should be immediately usable by analytics teams.
*   **Dimensional Integrity:** Gold models should preserve correct joins and lookup relationships.
*   **Historical Context:** Use snapshots to retain slowly changing dimension state over time.
*   **Performance Awareness:** Keep the Gold layer optimized for reporting and downstream query performance.
*   **Consistency:** Ensure fact rows align with the source of truth from Silver and snapshot state.

How to Use
----------

1. Run Silver models first to ensure enriched entity data exists.
2. Run snapshots to create `dim_bookings`, `dim_hosts`, and `dim_listings` in the Gold schema.
3. Run Gold models:

```bash
cd pipeline_project_dbt
dbt run --select gold
```

If snapshots have not been created yet, run:

```bash
dbt snapshot --select dim_bookings dim_hosts dim_listings
dbt run --select gold
```

Business Value
--------------

The Gold layer transforms refined data into the final enterprise-grade dataset for:

*   Reporting and BI dashboards.
*   Metric computation and KPI tracking.
*   Data exploration and ad hoc analysis.
*   Business decisions backed by consolidated Airbnb booking, host, and listing data.

Suggested Improvements
----------------------

*   Add model-level tests for `one_big_table` and `fact` to validate expected joins and column values.
*   Add descriptive metadata for all Gold layer columns.
*   Separate dimension and fact models into dedicated folders for clarity.
*   Consider materializing the Gold fact as a table or incremental model for production performance.

Layer Comparison
----------------

The Gold layer is the analytics-ready stage in the Medallion architecture. It differs from Bronze and Silver in these ways:

*   **Purpose:** build business-facing fact tables and reporting datasets.
*   **Transformation:** joins enriched Silver data with snapshot dimension state.
*   **Output:** Gold fact and dimension datasets optimized for analytics.
*   **Dependency:** consumes Silver outputs and snapshot tables to preserve historical context.

The Gold layer provides the final consolidated dataset for dashboards, metrics, and decision support.
