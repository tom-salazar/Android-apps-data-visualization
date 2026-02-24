create table playstore_apps (
	app_id int primary key not null,
	app_name varchar(220),
	category varchar(120),
	rating decimal(3,1),
	reviews int,
	file_size varchar(10),
	installs bigint,
	app_type varchar(10),
	price decimal(5,2),
	content_rating varchar(20)
);

select * from playstore_apps;

select distinct(app_type) from playstore_apps; -- type of app free/paid

select distinct(content_rating) from playstore_apps; -- type of users

select distinct(category) from playstore_apps; -- app categories

select category, max(installs) from playstore_apps
group by category;-- App that has highest installs by category

select max(installs) as highest_install from playstore_apps; -- highest installs 

select app_name, price from playstore_apps where price > 0; -- total paid apps - 662
select app_name, price from playstore_apps where price = 0; -- total free apps - 7564