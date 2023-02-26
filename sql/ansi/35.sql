-- query35
SELECT ca_state,
               cd_gender,
               cd_marital_status,
               cd_dep_count,
               count(*) cnt1,
               stddev_samp(cd_dep_count),
               avg(cd_dep_count),
               Max(cd_dep_count),
               cd_dep_employed_count,
               count(*) cnt2,
               stddev_samp(cd_dep_employed_count),
               avg(cd_dep_employed_count),
               Max(cd_dep_employed_count),
               cd_dep_college_count,
               count(*) cnt3,
               stddev_samp(cd_dep_college_count),
               avg(cd_dep_college_count),
               Max(cd_dep_college_count)
FROM   tpcds.customer c,
       tpcds.customer_address ca,
       tpcds.customer_demographics
WHERE  c.c_current_addr_sk = ca.ca_address_sk
       AND cd_demo_sk = c.c_current_cdemo_sk
       AND EXISTS (SELECT *
                   FROM   tpcds.store_sales,
                          tpcds.date_dim
                   WHERE  c.c_customer_sk = ss_customer_sk
                          AND ss_sold_date_sk = d_date_sk
                          AND d_year = 2001
                          AND d_qoy < 4)
       AND ( EXISTS (SELECT *
                     FROM   tpcds.web_sales,
                            tpcds.date_dim
                     WHERE  c.c_customer_sk = ws_bill_customer_sk
                            AND ws_sold_date_sk = d_date_sk
                            AND d_year = 2001
                            AND d_qoy < 4)
              OR EXISTS (SELECT *
                         FROM   tpcds.catalog_sales,
                                tpcds.date_dim
                         WHERE  c.c_customer_sk = cs_ship_customer_sk
                                AND cs_sold_date_sk = d_date_sk
                                AND d_year = 2001
                                AND d_qoy < 4) )
GROUP  BY ca_state,
          cd_gender,
          cd_marital_status,
          cd_dep_count,
          cd_dep_employed_count,
          cd_dep_college_count
ORDER  BY ca_state,
          cd_gender,
          cd_marital_status,
          cd_dep_count,
          cd_dep_employed_count,
          cd_dep_college_count
LIMIT 100