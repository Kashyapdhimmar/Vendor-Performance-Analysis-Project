-- TOTAL PURCHASE COST PER VENDOR

SELECT
	*
FROM
	VENDOR_INVOICE;

SELECT
	VI."vendornumber" AS VENDOR_ID,
	VI."vendorname" AS VENDOR_NAME,
	SUM(VI."quantity") AS TOTAL_PURCHASE_QUANTITY,
	SUM(VI."dollars") AS TOTAL_PURCHASE_COST,
	SUM(VI."freight") AS TOTAL_FREIGHT
FROM
	VENDOR_INVOICE VI
GROUP BY
	VI."vendornumber",
	VI."vendorname"
ORDER BY
	TOTAL_PURCHASE_COST DESC;

-- TOTAL SALES REVENUE PER VENDOR

SELECT
	*
FROM
	SALES;
	
SELECT
	S."vendorno" AS VENDOR_ID,
	S."vendorname" AS VENDOR_NAME,
	SUM(S."salesquantity") AS TOTAL_SALES_QUANTITY,
	SUM(S."salesdollars") AS TOTAL_SALES_REVENUE
FROM
	SALES S
GROUP BY
	S."vendorno",
	S."vendorname"
ORDER BY
	TOTAL_SALES_REVENUE DESC;

--------------------------------------------------PROFIT AND PROFIT MARGIN PER VENDOR---------------------------------------------

-- Combine All Aggregations

WITH 
    SALES_AGG AS (
        SELECT
            S."vendorno" AS VENDOR_ID,
            MAX(S."vendorname") AS VENDOR_NAME,
            SUM(S."salesdollars") AS TOTAL_SALES_REVENUE,
            SUM(S."salesquantity") AS TOTAL_SALES_QUANTITY
        FROM SALES S
        WHERE S."salesdollars" > 0
        GROUP BY S."vendorno"
    ),

    PURCH_AGG AS (
        SELECT
            VI."vendornumber" AS VENDOR_ID,
            MAX(VI."vendorname") AS VENDOR_NAME,
            SUM(VI."dollars") AS TOTAL_PURCHASE_COST,
            SUM(VI."quantity") AS TOTAL_PURCHASE_QUANTITY
        FROM VENDOR_INVOICE VI
        GROUP BY VI."vendornumber"
    ),

    FREIGHT_AGG AS (
        SELECT
            VI."vendornumber" AS VENDOR_ID,
            MAX(VI."vendorname") AS VENDOR_NAME,
            SUM(VI."freight") AS TOTAL_FREIGHT
        FROM VENDOR_INVOICE VI
        GROUP BY VI."vendornumber"
    )

SELECT
    COALESCE(s.VENDOR_ID, p.VENDOR_ID, f.VENDOR_ID) AS VENDOR_ID,
    COALESCE(s.VENDOR_NAME, p.VENDOR_NAME, f.VENDOR_NAME) AS VENDOR_NAME,
    COALESCE(s.TOTAL_SALES_QUANTITY, 0) AS TOTAL_SALES_QUANTITY,
    COALESCE(s.TOTAL_SALES_REVENUE, 0) AS TOTAL_SALES_REVENUE,
    COALESCE(p.TOTAL_PURCHASE_QUANTITY, 0) AS TOTAL_PURCHASE_QUANTITY,
    COALESCE(p.TOTAL_PURCHASE_COST, 0) AS TOTAL_PURCHASE_COST,
    COALESCE(f.TOTAL_FREIGHT, 0) AS TOTAL_FREIGHT,

    -- Profit Calculations
    (COALESCE(s.TOTAL_SALES_REVENUE, 0) - COALESCE(p.TOTAL_PURCHASE_COST, 0)) 
        AS PROFIT_EXCL_FREIGHT,

    (COALESCE(s.TOTAL_SALES_REVENUE, 0) 
     - COALESCE(p.TOTAL_PURCHASE_COST, 0) 
     - COALESCE(f.TOTAL_FREIGHT, 0)) 
        AS PROFIT_INCL_FREIGHT,

    -- Margin Calculations
    ROUND(
        (COALESCE(s.TOTAL_SALES_REVENUE, 0) - COALESCE(p.TOTAL_PURCHASE_COST, 0)) 
        / NULLIF(COALESCE(s.TOTAL_SALES_REVENUE, 0), 0) * 100, 2
    ) AS MARGIN_EXCL_FREIGHT_PCT,

    ROUND(
        (COALESCE(s.TOTAL_SALES_REVENUE, 0) 
         - COALESCE(p.TOTAL_PURCHASE_COST, 0) 
         - COALESCE(f.TOTAL_FREIGHT, 0)) 
        / NULLIF(COALESCE(s.TOTAL_SALES_REVENUE, 0), 0) * 100, 2
    ) AS MARGIN_INCL_FREIGHT_PCT

FROM SALES_AGG s
FULL OUTER JOIN PURCH_AGG p ON s.VENDOR_ID = p.VENDOR_ID
FULL OUTER JOIN FREIGHT_AGG f ON COALESCE(s.VENDOR_ID, p.VENDOR_ID) = f.VENDOR_ID
ORDER BY PROFIT_INCL_FREIGHT DESC;

--------------------------------------------------VENDOR RANKING (TOP & BOTTOM BY PROFIT)---------------------------------------------


WITH vendor_perf AS (
    WITH sales_agg AS (
        SELECT
            s."vendorno"           AS vendor_id,
            MAX(s."vendorname")    AS vendor_name,
            SUM(s."salesdollars")  AS total_sales_revenue,
            SUM(s."salesquantity") AS total_sales_qty
        FROM sales s
        WHERE s."salesdollars" > 0
        GROUP BY s."vendorno"
    ),
    purch_agg AS (
        SELECT
            vi."vendornumber"      AS vendor_id,
            MAX(vi."vendorname")   AS vendor_name,
            SUM(vi."dollars")      AS total_purchase_cost,
            SUM(vi."quantity")     AS total_purchase_qty
        FROM vendor_invoice vi
        GROUP BY vi."vendornumber"
    ),
    freight_agg AS (
        SELECT
            vi."vendornumber"      AS vendor_id,
            SUM(vi."freight")      AS total_freight
        FROM vendor_invoice vi
        GROUP BY vi."vendorNumber"
    )
    SELECT
        COALESCE(s.vendor_id, p.vendor_id) AS vendor_id,
        COALESCE(s.vendor_name, p.vendor_name) AS vendor_name,
        COALESCE(s.total_sales_revenue,0) - COALESCE(p.total_purchase_cost,0) - COALESCE(f.total_freight,0) AS profit_incl_freight
    FROM sales_agg s
    FULL OUTER JOIN purch_agg  p USING (vendor_id)
    FULL OUTER JOIN freight_agg f USING (vendor_id)
)
SELECT
    vendor_id,
    vendor_name,
    profit_incl_freight,
    RANK() OVER (ORDER BY profit_incl_freight DESC NULLS LAST) AS profit_rank_desc,
    RANK() OVER (ORDER BY profit_incl_freight ASC  NULLS LAST) AS profit_rank_asc
FROM vendor_perf
ORDER BY profit_incl_freight DESC NULLS LAST
LIMIT 10;

-- Bottom 10:

WITH vendor_perf AS (
    WITH sales_agg AS (
        SELECT
            s."vendorno"           AS vendor_id,
            MAX(s."vendorname")    AS vendor_name,
            SUM(s."salesdollars")  AS total_sales_revenue,
            SUM(s."salesquantity") AS total_sales_qty
        FROM sales s
        WHERE s."salesdollars" > 0
        GROUP BY s."vendorno"
    ),
    purch_agg AS (
        SELECT
            vi."vendornumber"      AS vendor_id,
            MAX(vi."vendorname")   AS vendor_name,
            SUM(vi."dollars")      AS total_purchase_cost,
            SUM(vi."quantity")     AS total_purchase_qty
        FROM vendor_invoice vi
        GROUP BY vi."vendornumber"
    ),
    freight_agg AS (
        SELECT
            vi."vendornumber"      AS vendor_id,
            SUM(vi."freight")      AS total_freight
        FROM vendor_invoice vi
        GROUP BY vi."vendornumber"
    )
    SELECT
        COALESCE(s.vendor_id, p.vendor_id) AS vendor_id,
        COALESCE(s.vendor_name, p.vendor_name) AS vendor_name,
        COALESCE(s.total_sales_revenue,0) - COALESCE(p.total_purchase_cost,0) - COALESCE(f.total_freight,0) AS profit_incl_freight
    FROM sales_agg s
    FULL OUTER JOIN purch_agg  p USING (vendor_id)
    FULL OUTER JOIN freight_agg f USING (vendor_id)
)
SELECT
    vendor_id,
    vendor_name,
    profit_incl_freight,
    RANK() OVER (ORDER BY profit_incl_freight DESC NULLS LAST) AS profit_rank_desc,
    RANK() OVER (ORDER BY profit_incl_freight ASC  NULLS LAST) AS profit_rank_asc
FROM vendor_perf
ORDER BY profit_incl_freight ASC NULLS LAST
LIMIT 10;








