select * from Trade_Data;

select * from Country_Info;

select * from GlobalFinanceData;

select * from Currency_History;

--List all countries and their population from Country_Info.
SELECT country,population_million 
FROM Country_Info;

--Show the top 5 countries with the highest Stock Market Index from GlobalFinanceData
SELECT country,stock_index 
FROM GlobalFinanceData 
ORDER BY stock_index DESC
LIMIT 5;

--Retrieve the latest exchange rate (against USD) for each country from Currency_History.
SELECT country,exchange_rate_usd 
FROM Currency_History ch
WHERE date = (SELECT MAX(date) FROM Currency_History WHERE country=ch.country);

--Find all countries in the continent "Asia" from Country_Info.
SELECT country, region, continent
FROM Country_Info 
WHERE continent = 'Asia';

--count how many countries have a credit rating of "AAA" in GlobalFinanceData.
SELECT country ,credit_rating
FROM GlobalFinanceData
WHERE credit_rating = 'AAA';

--Calculate the average GDP Growth (%) by continent using Country_Info + GlobalFinanceData.
SELECT ci.continent, AVG(gfd.gdp_growth_rate_percent) AS avg_growth
FROM Country_Info ci
JOIN GlobalFinanceData gfd ON ci.country = gfd.country
GROUP BY ci.continent;

--Find the top 5 countries with the largest positive trade balance (Exports - Imports) from Trade_Data.
SELECT country,(exports_billion-imports_billion) AS tradedata 
FROM Trade_Data
ORDER BY tradedata DESC 
LIMIT 5;

--Compare average Inflation Rate (%) for each region using Country_Info + GlobalFinanceData.
SELECT ci.region ,AVG(gfd.inflation_rate_percent) AS AIR
FROM Country_Info ci
JOIN GlobalFinanceData gfd ON ci.country = gfd.country
GROUP BY ci.region;


--Identify countries with currency volatility greater than 5% from GlobalFinanceData and list their latest exchange rate from Currency_History.
SELECT gfd.country , gfd.currency_volatility_percent , ch.exchange_rate_usd 
FROM GlobalFinanceData gfd
JOIN Currency_History ch ON gfd.country = ch.country
WHERE currency_volatility_percent > 5 
AND ch.date = (SELECT MAX(date) FROM currency_history WHERE country = ch.country);

--Show the top 3 most populous countries and their corresponding GDP Growth (%) from Country_Info + GlobalFinanceData.
SELECT ci.country, gfd.gdp_growth_percent ,ci.population_million
FROM Country_Info ci
JOIN GlobalFinanceData gfd ON ci.country = gfd.country
ORDER BY population_million desc
LIMIT 3;

--Rank countries by GDP Growth (%) within each continent using Country_Info + GlobalFinanceData.
SELECT ci.continent ,gfd.country,gfd.gdp_growth_percent,
RANK() OVER(PARTITION BY ci.continent ORDER BY gfd.gdp_growth_percent desc ) AS GDP_Growth
FROM GlobalFinanceData gfd 
JOIN Country_Info ci ON gfd.country = ci.country;

--For each continent, find the country with the highest Foreign Exchange Reserves from GlobalFinanceData.
SELECT continent, country, foreign_exchange_reserves_usd_billion
FROM (
    SELECT ci.continent, gfd.country, gfd.foreign_exchange_reserves_usd_billion,
           RANK() OVER (PARTITION BY ci.continent ORDER BY gfd.foreign_exchange_reserves_usd_billion ) AS rnk
    FROM GlobalFinanceData gfd
    JOIN Country_Info ci ON gfd.country = ci.country
) t
WHERE rnk = 1;


--Show monthly average exchange rate trends for each country (grouped by month) from Currency_History.
SELECT country, DATE_TRUNC('month', Date) AS month, AVG(exchange_rate_usd) AS avg_rate
FROM Currency_History
GROUP BY country, DATE_TRUNC('month', Date)
ORDER BY country, month;



--Find countries where Unemployment Rate (%) is above average but GDP Growth (%) is also above average, using GlobalFinanceData.
SELECT Country, GDP_Growth_Percent, Unemployment_Rate_Percent
FROM GlobalFinanceData
WHERE GDP_Growth_Percent > (SELECT AVG(GDP_Growth_Percent) FROM GlobalFinanceData)
AND Unemployment_Rate_Percent > (SELECT AVG(Unemployment_Rate_Percent) FROM GlobalFinanceData);



--Identify the top 3 trade-surplus countries per continent (where Exports > Imports) using Trade_Data + Country_Info.
SELECT ci.continent, td.country, (td.exports_billion - td.imports_billion) AS trade_surplus,
ROW_NUMBER() OVER (PARTITION BY ci.continent ORDER BY (td.exports_billion - td.imports_billion) DESC) AS rn
FROM Trade_Data td
JOIN Country_Info ci ON td.country = ci.country
WHERE td.exports_billion > td.imports_billion;
