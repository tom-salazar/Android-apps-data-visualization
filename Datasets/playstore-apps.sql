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
	*
	FROM
		(SELECT 
			Category, 
			SUM(Installs) AS total_download
		FROM playstore_apps_copy 
		GROUP BY Category)tc
		ORDER BY total_download DESC
),

HighestInstallByCategory AS
(	
	SELECT 
		Category,
		Installs
	FROM playstore_apps_copy 
	WHERE Installs = (SELECT MAX(Installs) AS ins FROM playstore_apps_copy)
), -- Most Apps Installed by Category

AppReviewsByCategory AS
(
	SELECT
	*
	FROM
		(SELECT
			Category,
			SUM(Reviews) AS total_reviews
		FROM playstore_apps_copy
		GROUP BY Category)tr
		ORDER BY total_reviews DESC
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
	*
	FROM
		(SELECT
			Category,
			COUNT(*) AS number_of_apps
		FROM playstore_apps_copy
		GROUP BY Category)na
		ORDER BY number_of_apps DESC
), -- Number of apps by category

TotalPaidApps AS
(
	SELECT 
	*
	FROM
		(SELECT 
			Type,
			Count(Price) AS number_of_paid_apps
		FROM playstore_apps_copy
		WHERE Price > 0
		GROUP BY Type)pa
), -- Number of paid apps: 527

TotalFreeApps AS
(
	SELECT 
	*
	FROM
		(SELECT 
			Type,
			Count(Price) AS number_of_free_apps
		FROM playstore_apps_copy
		WHERE Price = 0
		GROUP BY Type)fa
), -- Number of free apps: 6375

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






















/* DELETE DUPLICATES */
/* ---------------------------------

begin transaction;

	WITH cte_del AS
	(
		select 
			AppName, row_number() over(partition by AppName order by AppName) as rn
		from playstore_apps_copy
	)
	delete from cte_del where rn > 1; -- delete duplicates

rollback; -- commit;

/* ----------------------------------------------- END ---------------------

/* REPLACE @ to empty string in AppName
-------------------------------------

select AppID, AppName from playstore_apps_copy
	where AppName like '%@%';

update playstore_apps_copy set AppName = REPLACE(AppName, '@', '')
begin transaction;
rollback; --commit;

*/ ------------------------------------- END ----------------------

/* DELETE AppName with unknown characters 
--------------------------------------------------

delete from playstore_apps_copy where AppID IN (
325, 10764, 10532, 10223, 10209, 10175, 10110, 9820, 9467, 9438, 9370,
310, 9279, 9118, 8568, 7464, 7221, 6847, 6630, 5377, 322,
9318, 9309, 9249, 8995, 8903, 8666, 8569, 8395, 8323, 7819, 7666,
7411, 7406, 7397, 7209, 6843, 6844, 6842, 6840, 6836, 6835, 6833, 6832,
6830, 6819, 6806, 6806, 6558, 6421, 6419, 6418, 6416, 6407, 6389,
6335, 6202, 6166, 6007, 5699, 5653, 5603, 5570, 5514, 5347, 5267,
5087, 5067, 4432, 4474, 4483, 4486, 4551, 4363, 4325, 4194, 3825,
4760, 47650, 3983, 5180, 5259, 8680, 8889, 47, 55, 56, 60, 63, 71, 85, 90,
95, 96, 102, 221, 300, 312, 317, 335, 482, 565, 585,
179, 327, 600, 2467, 3726, 4745,
579, 722, 728, 790, 868, 1192, 1192, 1202, 1233, 1304, 1452, 1453, 1473, 1475, 3142, 3160, 3164, 
3609, 3647, 3699, 3748, 3824, 3846, 5816, 5943, 7023, 7746, 7994, 8005, 8019, 8623, 9036, 9475, 9537,
9673, 9678, 9735, 9737, 9745, 9763, 1482, 1490, 1588, 1614, 2414, 2697, 2807, 2824
3617, 3751, 3601, 3410, 2704, 2576, 1593, 1489, 1453); --AppName with unknown characters and unreadable

*/--------------------------------------------------END-------------------------------------

/* ---- UPDATE AppName -------

update playstore_apps_copy set AppName = 'Canva Poster Banner Card Maker' where AppID = 46
update playstore_apps_copy set AppName = 'Comic Shojo Manga' where AppID = 311
update playstore_apps_copy set AppName = 'English Communication Learn English for Chinese' where AppID = 702
update playstore_apps_copy set AppName = 'Quick Books' where AppID = 1124
update playstore_apps_copy set AppName = 'Cookpad Free Recipe' where AppID = 1179
update playstore_apps_copy set AppName = 'Delish Kitchen Free' where AppId = 1180
update playstore_apps_copy set AppName = 'Recipes Pastries and Homemade Pies' where AppId = 1215
update playstore_apps_copy set AppName = 'Dead Target FPS Zombie Apocalypse Survival' where AppID = 1937
update playstore_apps_copy set AppName = 'Photo Wonder Pro Beauty Photo Editor' where AppID = 2915
update playstore_apps_copy set AppName = 'Live Camera Viewer' where AppID = 5447
update playstore_apps_copy set AppName = 'Body Scanner Xray Real Camera Prank' where AppID = 6113
update playstore_apps_copy set AppName = 'Cut Out Background Eraser' where AppID = 6194
update playstore_apps_copy set AppName = 'Dungeon Legends PvP' where AppID = 7664
update playstore_apps_copy set AppName = 'Neon Blue Gaming Wallpaper Theme for Lenovo' where AppID = 10707

*/-----------------------------------END-----------------------------------