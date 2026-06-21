Bronze Layer
============

Overview
--------

This folder contains the models responsible for building the **Bronze layer** of the **Medallion Architecture**. The Bronze layer is the raw ingestion stage where source data is brought into Snowflake with minimal transformation, preserving the original payload for auditing, lineage, and downstream processing.

The primary objective of this layer is to provide a stable, raw copy of source tables in Snowflake, while enabling incremental ingestion to support repeatable pipelines and efficient refreshes.

Data Ingestion & Transformations
--------------------------------

The Bronze layer follows a simple, raw ingestion pattern:

*   **Source ingestion**
    *   Reads directly from staging tables defined in `models/sources.yml`.
    *   Uses `{{ source('source_stage', '<table>') }}` to guarantee source metadata and lineage.
*   **Minimal transformation**
    *   Selects all columns from the source tables.
    *   Preserves raw values and source column formats.
*   **Incremental load**
    *   Applies a `CREATED_AT` watermark to load only new rows.
    *   Avoids full refreshes for better performance and lower cost.

Primary Models
--------------

*   `bronze_bookings.sql`
    *   Ingests raw booking records from `source_stage.bookings`.
    *   Uses incremental loading based on `CREATED_AT`.
*   `bronze_hosts.sql`
    *   Ingests raw host records from `source_stage.hosts`.
    *   Uses incremental loading based on `CREATED_AT`.
*   `bronze_listings.sql`
    *   Ingests raw listing records from `source_stage.listings`.
    *   Uses incremental loading based on `CREATED_AT`.

Incremental Behavior
--------------------

Each Bronze model is materialized as an incremental table. The load logic is:

*   Insert all rows from the source table.
*   If the model already exists, only select rows where `CREATED_AT` is greater than the current maximum value in the target table.
*   Use `COALESCE(MAX(CREATED_AT), '1900-01-01')` to handle initial table creation.

### Why this approach?

*   **Efficiency:** Only new rows are processed on subsequent runs.
*   **Stability:** The Bronze layer keeps a raw source copy of the data.
*   **Lineage:** Source relationships are explicit via `{{ source(...) }}`.
*   **Simplicity:** Minimal business transformation happens here, reducing risk.

Design Principles
-----------------

*   **Raw Persistence:** Store source data with minimal schema changes.
*   **Incrementality:** Process only new or changed data during refreshes.
*   **Auditability:** Preserve original data values for downstream tracing.
*   **Separation of concerns:** Keep business logic and enrichment out of Bronze.

How to Use
----------

1. Confirm staging source tables are available in Snowflake.
2. Run Bronze models first to populate the raw ingestion layer:

```bash
cd pipeline_project_dbt
dbt run --select bronze
```

3. After Bronze completes, run Silver models to refine and enrich the data.

Suggested Improvements
----------------------

*   Add tests for source existence and non-null primary keys in Bronze models.
*   Add explicit column documentation for each Bronze target table.
*   Enhance incremental logic to support deleted or updated source rows if needed.
*   Add a staging validation step to ensure raw source data quality before ingestion.

Layer Comparison
----------------

The Bronze layer is the raw ingestion stage in the Medallion architecture. It differs from Silver and Gold in these ways:

*   **Purpose:** preserve raw source data with minimal transformation.
*   **Transformation:** no business logic, only incremental ingestion.
*   **Output:** raw Bronze tables used as the foundation for Silver.
*   **Dependency:** consumes Snowflake staging tables and provides source data for Silver.

The Bronze layer is ideal for auditing, lineage, and replaying data from the original source.
