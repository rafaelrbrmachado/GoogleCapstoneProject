# Google Data Analytics Capstone Project
Welcome to the Cyclistic bike-share analysis case study! In this case study, I performed real-world tasks of a junior data analyst for a fictional company, Cyclistic.

#### Quick Links :link:
* [Tableau Dashboard](https://public.tableau.com/shared/XZS6Z7PZF?:display_count=n&:origin=viz_share_link) - Data Visualization.
* [Raw Public Data](https://divvy-tripdata.s3.amazonaws.com/index.html) - The data has been made available by Motivate International Inc. under this [license](https://ride.divvybikes.com/data-license-agreement).

## About the company :bicyclist:
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system at any time.
One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who buy annual memberships are Cyclistic members.

## Business task :dart:
Cyclistic’s finance analysts concluded that annual members are much more profitable than casual riders. The marketing director, Lily Moreno, believes that maximizing the number of annual members will be critical to future growth. Design marketing strategies aimed at converting casual riders into annual members. Three questions will guide the future marketing program:

*	**How do annual members and casual riders use Cyclistic bikes differently?**
*	Why would casual riders buy Cyclistic annual memberships?
*	How can Cyclistic use digital media to influence casual riders to become members?

The director of marketing assigned me the first question to answer.

## About the data :open_file_folder:
To complete this case study, I analyzed the previous 12 months’ Cyclistic bike trip data (see Quick Links section above). The data was reliable, free of bias, collected by Cyclistic, and stored monthly on the company’s database in CSV format. For this project, I used the data from April 2022 to March 2023.

## Data processing :computer:
Unfortunately, not all the CSV files could be uploaded into Microsoft Excel or SQL on Google’s BigQuery platform (local uploads are limited to 100 MB). Keeping that in mind, I decided to use R to clean, transform and analyze the data.

Too see the full R script on Github please click [here](https://github.com/rafaelrbrmachado/GoogleCapstoneProject/blob/main/R%20Script%20Analysis).

#### Step 1: Data Combination and Exploration
After importing all the 12 CSV files, they were aggregated into a single dataset called ‘all_trips’. Here is a quick overview of the columns:

* ride_id (unique ID for each ride)
* rideable_type (data about the type of bikes used)
* started_at (date and time that the bike trips started)
* ended_at (date and time that the bike trips ended)
* start_station_name (station name where bike trips started)
* start_station_id (station ID where bike trips started)
* end_station_name (station name where bike trips ended)
* end_station_id (station ID where bike trips ended)
* start_lat (latitude where bike trips started)
* start_lng (longitude where bike trips started)
* end_lat (latitude where bike trips ended)
* end_lng (longitude where bike trips ended)
* member_casual (user type: casual riders or Cyclistic members)

#### Step 2: Data Transformation
After having me make sure that the data was consistent, I proceeded to add new columns to the dataset to have a more robust analysis. I added separate columns listing the day of the week, day of the month, month, and year as another column for the ride length.

#### Step 3: Data Cleaning
After exploring the data I came across with three main problems:
* The data frame included entries where "ride_length" is negative.
* The data frame included entries where the bikes were taken for quality control ("HQ QR" stations).
* "start_station" and "end_station" columns had NA values

So, I proceeded to clean these columns.

## Analyze and Data Visualization :bar_chart:
At this point, all the data was consistent and complete. So, I started analyzing it and created several visuals using Tableau Public which culminated in a comprehensive Dashboard that can be accessed [here](https://public.tableau.com/shared/PWXF53FNQ?:display_count=n&:origin=viz_share_link).

## Findings :mag:
During this period 4.482.290 trips were taken. Members represented approximately 60% of all trips, while casual riders represented about 40%, and for both user types, classic bikes are the most used.

The variations in the number of bike trips taken by the month and by day of the month were very similar between members and casual riders despite members taking more rides. Regarding monthly activity, more rides were taken during late spring, summer, and early autumn.

Interestingly, members took more trips during the week, while casual riders’ activity significantly increased during the weekend, surpassing the members’ activity during this period.

The average ride length is greater for casual riders (approximately 23 minutes) than for annual members (approximately 12 minutes). This difference is even bigger during the weekend.

One last thing was considered: the starting and ending stations distribution. Looking at both maps, two different trends were visualized. First, casual riders frequently use stations near recreational areas such as the coast or parks. On the other end, annual members have a more even distribution across the city.

## Summary of Insights :clipboard:
Let's take a step back and recall our **Business Question**:
*	How do annual members and casual riders use Cyclistic bikes differently?

Casual Riders:
* More activity during the weekend.
* Longer rides.
* Tend to start and end their trips near recreational areas.

Annual Members:
* More activity during the week.
* Shorter rides.
* Even distribution across the city

These insights strongly suggest that casual riders use Cyclistic bikes for leisure while annual members use Cyclistic bikes daily for commuting to or off work.

## Recommendations :bulb:
* Cyclistic could offer personalized and increased discounts to new annual members based on their traveled distances.
* Cyclistic could create a new subscription plan offering full access only on weekends.
* These new plans and discounts should be advertised especially during the warmer months, preferably in strategic locations such as the stations near recreational areas.
