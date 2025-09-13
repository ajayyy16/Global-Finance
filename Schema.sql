--Finance Data

--Creating GlobalFinanceData Table
CREATE TABLE GlobalFinanceData (
    Country VARCHAR(50),
    Date DATE,
    Stock_Market_Index DECIMAL(12,2),
    Daily_Change_Percent DECIMAL(5,2),
    Inflation_Rate_Percent DECIMAL(5,2),
    GDP_Growth_Percent DECIMAL(5,2),
    Interest_Rate_Percent DECIMAL(5,2),
    Foreign_Exchange_Reserves_USD_Billion DECIMAL(15,2),
    Credit_Rating VARCHAR(10),
    Unemployment_Rate_Percent DECIMAL(5,2),
    Currency_Volatility_Percent DECIMAL(5,2),
    Trade_Balance_Percent_GDP DECIMAL(5,2),
    Economic_Outlook VARCHAR(20)
);


--Creating Country_Info Table
CREATE TABLE Country_Info (
    Country VARCHAR(100) PRIMARY KEY,
    Region VARCHAR(100),
    Population_Million DECIMAL(10,2),
    Continent VARCHAR(50)
);


--Creating Trade_Data Table
CREATE TABLE Trade_Data (
    Trade_ID SERIAL PRIMARY KEY,
    Country VARCHAR(100),
    Year INT,
    Exports_Billion DECIMAL(12,2),
    Imports_Billion DECIMAL(12,2),
    FOREIGN KEY (Country) REFERENCES Country_Info(Country)
);


--Creating Currency_History Table
CREATE TABLE Currency_History (
    History_ID SERIAL PRIMARY KEY,
    Country VARCHAR(100),
    Date DATE,
    Currency_Code VARCHAR(10),
    Exchange_Rate_USD DECIMAL(10,4),
    FOREIGN KEY (Country) REFERENCES Country_Info(Country)
);