/* Playstore apps dataset from 2011 - 2018 */
/* Naming Conventions:
	CTE and Table column names: PascalCase w/ underscore - EveryFirstWordLetterInUpperCase
	SQL Queries: Uppercase
	Alias names: snake_case - lower case and word separated by underscore
*/


-- Total Installs by Category
-- Highest Install by Category

-- App Reviews by Category
-- Most Installed App
-- Number of apps by Category
-- Total paid & free apps

-- App type
-- Type of Users
-- App Categories


WITH TotalInstallByCategory AS
(
	SELECT 
		Category, 
		SUM(Installs) AS total_download
	FROM playstore_apps_copy 
	GROUP BY Category
), -- Total Downloads by Category

HighestInstallByCategory AS
(	
	SELECT 
		Category,
		Installs
	FROM playstore_apps_copy 
	WHERE Installs = (SELECT MAX(Installs) AS ins FROM playstore_apps_copy)
), -- Most Apps Installed by Category: Game, News and Magazines

AppReviewsByCategory AS
(
	
	SELECT
		Category,
		SUM(Reviews) AS total_reviews
	FROM playstore_apps_copy
	GROUP BY Category
), -- App reviews by Category

MostDownloaddApp AS
(
	SELECT
		AppID,
		AppName,
		Installs
	FROM playstore_apps_copy
	WHERE Installs = (SELECT MAX(Installs) AS total_download FROM playstore_apps_copy)
), -- Most download apps: Subway Surfers, Google News

NumberOfAppsByCategory AS
(
	SELECT
		Category,
		COUNT(*) AS number_of_apps
	FROM playstore_apps_copy
	GROUP BY Category
), -- Number of apps by category

TotalPaidFreeApps AS (
	SELECT
		Type,
		Count(*) AS number_of_apps,
		SUM(CASE WHEN Price = 0 THEN 1 ELSE 0 END) AS free_apps,
		SUM(CASE WHEN Price > 0 THEN 1 ELSE 0 END) AS paid_apps
	FROM playstore_apps_copy
	GROUP BY Type
), -- Total of free apps and paid apps

AppType AS
(
	SELECT 
		Type
	FROM playstore_apps_copy
	GROUP BY Type
), -- Types of an app: Free/Paid

UsersType AS
(
	SELECT
		Content_Rating
	FROM playstore_apps_copy
	GROUP BY Content_Rating
), -- Users: Everyone 10+, Teen, Mature 17+, Unrated, Everyone, Adults only 18+

AppCategories AS
(
	SELECT 
		Category
	FROM playstore_apps_copy
	GROUP BY Category
) -- Apps Categories


SELECT * FROM playstore_apps_copy ORDER BY Last_Updated;
