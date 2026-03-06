SELECT count (lead_id) FROM funnel;
SELECT COUNT(qualified_flag) FROM funnel where qualified_flag=1;
SELECT COUNT(demo_flag) FROM funnel where demo_flag=1;
SELECT COUNT(proposal_flag) FROM funnel where proposal_flag=1;
SELECT COUNT(won_flag) FROM funnel where won_flag=1;


SELECT
    ROUND(
        SUM(CASE WHEN Qualified_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS lead_to_qualified_pct,

    ROUND(
        SUM(CASE WHEN Demo_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(SUM(CASE WHEN Qualified_Date IS NOT NULL THEN 1 ELSE 0 END),0),
    2) AS qualified_to_demo_pct,

    ROUND(
        SUM(CASE WHEN Proposal_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(SUM(CASE WHEN Demo_Date IS NOT NULL THEN 1 ELSE 0 END),0),
    2) AS demo_to_proposal_pct,

    ROUND(
        SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(SUM(CASE WHEN Proposal_Date IS NOT NULL THEN 1 ELSE 0 END),0),
    2) AS proposal_to_won_pct
FROM funnel;

SELECT
    COUNT(*) -
    SUM(CASE WHEN Qualified_Date IS NOT NULL THEN 1 ELSE 0 END)
    AS dropped_before_qualification,

    SUM(CASE WHEN Qualified_Date IS NOT NULL THEN 1 ELSE 0 END) -
    SUM(CASE WHEN Demo_Date IS NOT NULL THEN 1 ELSE 0 END)
    AS dropped_after_qualification,

    SUM(CASE WHEN Demo_Date IS NOT NULL THEN 1 ELSE 0 END) -
    SUM(CASE WHEN Proposal_Date IS NOT NULL THEN 1 ELSE 0 END)
    AS dropped_after_demo,

    SUM(CASE WHEN Proposal_Date IS NOT NULL THEN 1 ELSE 0 END) -
    SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END)
    AS dropped_after_proposal
FROM funnel;

SELECT
    ROUND(
        (COUNT(*) -
        SUM(CASE WHEN Qualified_Date IS NOT NULL THEN 1 ELSE 0 END))
        * 100.0 / COUNT(*),
    2) AS drop_before_qualification_pct
FROM funnel;

SELECT
    Lead_Source,
    COUNT(*) AS total_leads,
    SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    ROUND(
        SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS win_rate_pct
FROM funnel
GROUP BY Lead_Source
ORDER BY win_rate_pct DESC;

SELECT
    Lead_Source,
    ROUND(SUM(Deal_Value),2) AS total_revenue
FROM funnel
WHERE Deal_Status = 'Won'
GROUP BY Lead_Source
ORDER BY total_revenue DESC;

SELECT
    Sales_Rep,
    COUNT(*) AS total_leads,
    SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    ROUND(
        SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS win_rate_pct
FROM funnel
GROUP BY Sales_Rep
ORDER BY win_rate_pct DESC;

SELECT
    Sales_Rep,
    ROUND(SUM(Deal_Value),2) AS total_revenue
FROM funnel
WHERE Deal_Status = 'Won'
GROUP BY Sales_Rep
ORDER BY total_revenue DESC;

SELECT
    ROUND(AVG(Days_to_Qualify),2) AS avg_days_to_qualify,
    ROUND(AVG(Days_to_Demo),2) AS avg_days_to_demo,
    ROUND(AVG(Days_to_Proposal),2) AS avg_days_to_proposal,
    ROUND(AVG(Days_to_Close),2) AS avg_days_to_close
FROM funnel;

SELECT
    Sales_Rep,
    ROUND(AVG(Days_to_Close),2) AS avg_close_time
FROM funnel
WHERE Deal_Status = 'Won'
GROUP BY Sales_Rep
ORDER BY avg_close_time DESC;

SELECT
    Lead_Source,
    ROUND(AVG(Days_to_Demo),2) AS avg_days_to_demo
FROM funnel
GROUP BY Lead_Source
ORDER BY avg_days_to_demo DESC;

SELECT
    ROUND(AVG(Deal_Value),2) AS avg_deal_value
FROM funnel
WHERE Deal_Status = 'Won';

SELECT
    Industry,
    ROUND(AVG(Deal_Value),2) AS avg_deal_value,
    ROUND(SUM(Deal_Value),2) AS total_revenue
FROM funnel
WHERE Deal_Status = 'Won'
GROUP BY Industry
ORDER BY total_revenue DESC;

SELECT
    'Lead → Qualified' AS stage, ROUND(AVG(Days_to_Qualify),2) AS avg_days FROM funnel
UNION ALL
SELECT
    'Qualified → Demo', ROUND(AVG(Days_to_Demo),2) FROM funnel
UNION ALL
SELECT
    'Demo → Proposal', ROUND(AVG(Days_to_Proposal),2) FROM funnel
UNION ALL
SELECT
    'Proposal → Close', ROUND(AVG(Days_to_Close),2) FROM funnel
ORDER BY avg_days DESC;

SELECT
    Region,
    COUNT(*) AS total_leads,
    SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) AS won_deals,
    ROUND(
        SUM(CASE WHEN Deal_Status = 'Won' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
    2) AS win_rate_pct
FROM funnel
GROUP BY Region
ORDER BY win_rate_pct DESC;
