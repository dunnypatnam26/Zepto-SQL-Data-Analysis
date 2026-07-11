
USE zepto;
SELECT * FROM zepto.zepto_v2;
SELECT COUNT(*) AS total_products
FROM zepto_v2;

               #data exploration
               
SELECT DISTINCT category
FROM zepto_v2;
SELECT name,mrp
	FROM zepto_v2
    ORDER BY mrp DESC
    LIMIT 10;
    SELECT COUNT(*) FROM zepto_v2;
    ALTER TABLE zepto_v2
ADD COLUMN sku_id INT AUTO_INCREMENT PRIMARY KEY FIRST;
 
                           #sample data
                           
    SELECT * FROM zepto_v2
    LIMIT 10;
    
          #result grid what rows are existing is shown
          
 SELECT MIN(sku_id), MAX(sku_id)
 FROM zepto_v2;
 SELECT COUNT(DISTINCT sku_id)
FROM zepto_v2;
 DESCRIBE zepto_v2;
 
     #null valuess

SELECT * FROM zepto_v2
WHERE name IS NULL
   OR sku_id IS NULL
   OR Category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outofStock IS NULL
   OR quantity IS NULL;
   
      #differnt product categrories with nmbers
       SELECT
ROW_NUMBER() OVER (ORDER BY Category) AS S_No,
Category
FROM (
   SELECT distinct Category
   FROM zepto_v2
   ORDER BY category
) AS categories;
#instock nd outstock
SELECT OutOfStock, COUNT(sku_id)
FROM zepto_v2
GROUP BY outOfStock;

#product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto_v2
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;
#datacleaning #prodouct price = 0
SELECT * FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;
#by this the sql workbench will ask us to confrm if we want to deleete or modify
 SET SQL_SAFE_UPDATES=0;
 
 #convert paisa to rupeees
SET SQL_SAFE_UPDATES = 0;
UPDATE zepto_v2
 SET mrp = mrp / 100.0,
 discountedSellingPrice = discountedSellingPrice / 100.0;
 SET SQL_SAFE_UPDATES = 1;
SELECT mrp , discountedSellingPrice FROM zepto_v2;
 
  
-- Find the top 10 best-value products based on the discount percentage
 SELECT
    sku_id,
    name,
    category,
    mrp,
    discountedSellingPrice,
    discountPercent
FROM zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

 -- What are the products with High MRP but Out of Stock
 SELECT DISTINCT name,mrp,sku_id
 FROM zepto_v2
 WHERE outOfStock = TRUE and mrp > 300
 ORDER BY mrp DESC
;
SELECT COUNT(*)
FROM zepto_v2
WHERE outOfStock = 1;
-- Calculate Estimated Revenue for each category
SELECT
    category,
    SUM(availableQuantity * discountedSellingPrice) AS estimated_revenue
FROM zepto_v2
GROUP BY category
ORDER BY estimated_revenue DESC;
-- Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT distinct sku_id, name, category, mrp, discountedSellingPrice,
    discountPercent
FROM zepto_v2
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC;

-- Identify the top 5 categories offering the highest average discount percentage.
SELECT Category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto_v2
GROUP  BY Category
ORDER BY avg_discount DESC
LIMIT 5;
-- Find the price per gram for products above 100g and sort by best value.
SELECT
    sku_id,name,category,weightInGms,discountedSellingPrice,
    ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto_v2
WHERE weightInGms > 100
ORDER BY price_per_gram ASC;
-- Group the products into categories like Low, Medium, Bulk.
SELECT
    sku_id,
    name,
    category,
    weightInGms,
    CASE
        WHEN weightInGms < 500 THEN 'Low'
        WHEN weightInGms BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Bulk'
    END AS weightInGms_category
FROM zepto_v2
ORDER BY weightInGms ;
-- What is the Total Inventory Weight Per Category
SELECT
    category,
    SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto_v2
GROUP BY category
ORDER BY total_inventory_weight DESC;                 