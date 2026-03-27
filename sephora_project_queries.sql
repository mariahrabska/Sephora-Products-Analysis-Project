-------------------------------------------------------------------------
-- Pricing & Promotion
-- % produktów na promocji
SELECT 
    ROUND(100.0 * SUM(on_sale) / COUNT(*), 2) AS percent_products_on_sale
FROM dim_products;

-- Średni rabat (tylko promocje)
SELECT 
    ROUND(AVG(discount_percentage)::numeric, 2) AS avg_discount_percentage
FROM dim_products
WHERE on_sale = 1;

-- Średni rabat według kategorii
SELECT 
    primary_category,
    ROUND(AVG(discount_percentage)::numeric, 2) AS avg_discount_percentage
FROM dim_products
WHERE on_sale = 1
GROUP BY primary_category
ORDER BY avg_discount_percentage DESC;


-- Czy droższe produkty są rzadziej przeceniane?
SELECT
    price_range,
    ROUND(AVG(on_sale) * 100, 2) AS percent_on_sale
FROM dim_products
GROUP BY price_range
ORDER BY percent_on_sale DESC;


-- Marki najczęściej oferujące rabaty
SELECT
    brand_name,
    ROUND(AVG(on_sale) * 100, 2) AS percent_products_on_sale,
    COUNT(*) AS product_count
FROM dim_products
GROUP BY brand_name
HAVING COUNT(*) >= 10
ORDER BY percent_products_on_sale DESC;

--Rozkład rabatów
SELECT
    discount_bucket,
    COUNT(*) AS product_count
FROM dim_products
WHERE on_sale = 1
GROUP BY discount_bucket
ORDER BY product_count DESC;




----------------------------------------------------------------------------
-- Ratings & Reviews
-- Czy produkty na promocji mają więcej recenzji?
SELECT 
    on_sale,
    COUNT(*) AS product_count,
    SUM(reviews) AS total_reviews,
    ROUND(AVG(reviews), 2) AS avg_reviews_per_product
FROM dim_products
GROUP BY on_sale
ORDER BY total_reviews DESC;


-- Czy rating różni się między produktami na promocji i bez?
SELECT on_sale, 
	COUNT(*) as total_products, 
	COUNT(rating) as products_with_rating,  
	ROUND(AVG(rating),2) AS avg_rating_per_product
FROM dim_products
GROUP BY on_sale;


-- Które marki mają najwyższy średni rating (min X recenzji)?
SELECT brand_name, 
	ROUND(AVG(rating),2) AS avg_rating_per_product,
	SUM(reviews) AS total_reviews
FROM dim_products
GROUP BY brand_name
HAVING SUM(reviews) > 10000
ORDER BY avg_rating_per_product DESC

-- Czy liczba recenzji koreluje z ratingiem?
SELECT 
    ROUND(corr(rating, reviews)::numeric, 4) AS correlation_coefficient
FROM dim_products
WHERE rating IS NOT NULL;


SELECT * FROM dim_products where rating IS NULL

-- Które kategorie mają najwięcej nisko ocenianych produktów (<3)?
SELECT primary_category,
	COUNT(*) AS total_products,
	SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) AS low_rated_products,
	ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS low_rated_pct
FROM dim_products
GROUP BY primary_category
ORDER BY low_rated_products DESC


--Nisko oceniane produkty w podkategoriach
SELECT 	primary_category,
	secondary_category,
	COUNT(*) AS total_products,
	SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) AS low_rated_products,
	ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END)*100/COUNT(*), 2) AS low_rated_pct
FROM dim_products
GROUP BY primary_category, secondary_category
ORDER BY primary_category DESC, low_rated_pct DESC


----------------------------------------------------------------
-- Popularity & Demand

--Czy produkty z wysokim loves_count są droższe?
SELECT popularity, 
	ROUND(AVG(loves_count),2) AS avg_loves_count_per_product,
	ROUND(AVG(price_usd), 2) AS  avg_price
FROM dim_products
GROUP BY popularity
ORDER BY avg_loves_count_per_product DESC


--Top 10 najbardziej lubianych marek
SELECT brand_name,
	SUM(loves_count) AS total_loves_count,
	ROUND(AVG(loves_count), 2) AS avg_loves_per_product
FROM dim_products
GROUP BY brand_name
ORDER BY total_loves_count DESC
LIMIT 10


--Czy nowe produkty generują więcej recenzji niż pozostałe?
SELECT 
    is_new,
    ROUND(
        100.0 * SUM(has_reviews) / COUNT(*),
        2
    ) AS percent_with_reviews
FROM dim_products
GROUP BY is_new;



--Czy Sephora exclusives mają wyższe ceny / ratingi?
SELECT sephora_exclusive, 
ROUND(AVG(price_usd), 2) as avg_price_usd, 
ROUND(AVG(rating), 2) as avg_rating
FROM dim_products 
GROUP BY sephora_exclusive


--Które kategorie generują największe zainteresowanie?
SELECT primary_category,
	secondary_category,
	SUM(loves_count) AS total_loves_count,
	ROUND(AVG(loves_count),2) AS avg_loves_per_product
FROM dim_products
GROUP BY primary_category, secondary_category
ORDER BY total_loves_count DESC



-------------------------------------------------
--REVIEWS

--Czy recenzje polecające mają wyzsze oceny produktu?
SELECT is_recommended, ROUND(AVG(rating),2) as avg_rating_per_product
FROM fact_reviews
GROUP BY is_recommended

-- Czy helpfulness koreluje z długością recenzji?
SELECT ROUND(corr(helpfulness, LENGTH(review_text))::numeric,2) as correlation_coefficient
FROM fact_reviews
WHERE helpfulness IS NOT NULL;
--buckety stworzyc w python


-- Jak zmienia się liczba recenzji w czasie?
SELECT 
	TO_CHAR(submission_time::TIMESTAMP, 'YYYY-MM') AS year_month,
	COUNT(*) AS review_count
FROM fact_reviews
GROUP BY year_month
ORDER BY year_month

select row_id, primary_category from fact_reviews, di
where primary_category IS NOT "Skincare"


-- Czy produkty o wysokim ratingu mają więcej pozytywnych reakcji?
SELECT p.rating_category,
	ROUND(AVG(r.helpfulness),2) as avg_helpfulness_per_review
from dim_products p
LEFT JOIN fact_reviews r ON p.product_id = r.product_id
WHERE p.rating_category IS NOT NULL
GROUP BY p.rating_category
ORDER BY avg_helpfulness_per_review DESC


