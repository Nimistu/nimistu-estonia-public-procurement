-- Estonia public procurement 2024 — OpenSpending export.
-- Value-disclosed awarded contracts (all public buyers), one row per winner.
-- Source: nimistu `procurements` table (riigihanke register eForms feed),
-- winner cross-referenced to the Estonian Business Register (äriregister).
-- Run on the nimistu prod DB:  psql "$DATABASE_URL" -f scripts/export.sql > data/estonia-public-procurement-2024.csv
COPY (
  SELECT
    p.notice_id,
    p.register_number,
    p.buyer_name,
    p.buyer_reg_code,
    p.winner_name,
    p.winner_reg_code,
    CASE WHEN p.winner_company_id IS NOT NULL THEN 'true' ELSE 'false' END AS winner_in_ariregister,
    cw.status AS winner_status,
    p.title,
    (p.cpv_codes->>0) AS cpv_main,
    array_to_string(ARRAY(SELECT jsonb_array_elements_text(p.cpv_codes)), ';') AS cpv_all,
    p.total_amount AS amount,
    p.currency,
    p.award_date,
    p.contract_end_date,
    p.procedure_type,
    CASE p.procedure_type
      WHEN 'open'        THEN 'Open'
      WHEN 'restricted'  THEN 'Restricted'
      WHEN 'neg-w-call'  THEN 'Negotiated with prior call'
      WHEN 'neg-wo-call' THEN 'Negotiated without prior call'
      WHEN 'comp-dial'   THEN 'Competitive dialogue'
      WHEN 'oth-single'  THEN 'Other (single stage)'
      WHEN 'oth-mult'    THEN 'Other (multiple stage)'
      ELSE p.procedure_type
    END AS procedure_label,
    p.bidder_count,
    p.source_url
  FROM procurements p
  LEFT JOIN companies cw ON cw.id = p.winner_company_id
  WHERE extract(year from p.award_date) = 2024
    AND p.total_amount IS NOT NULL
  ORDER BY p.award_date, p.notice_id, p.winner_reg_code
) TO STDOUT WITH (FORMAT csv, HEADER true);
