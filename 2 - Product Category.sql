select 
Case 
  	when price<100 then  "Low Price" 
  	when price between 100 and 500 then  "Medium Price" 
  	when price>500 then  "High Price" 
End as category,
count(Product_id) as no_of_products 
from products
group by category
order by no_of_products desc;
