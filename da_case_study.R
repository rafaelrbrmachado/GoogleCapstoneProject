# Load Packages
library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data

# Set working directory
setwd("C:/Users/rafa_/OneDrive/Área de Trabalho/Case Study DA/data_12_month")

# Upload Divvy datasets (last 12 months)
d_202303 <- read_csv("202303-divvy-tripdata.csv")
d_202302 <- read_csv("202302-divvy-tripdata.csv")
d_202301 <- read_csv("202301-divvy-tripdata.csv")
d_202212 <- read_csv("202212-divvy-tripdata.csv")
d_202211 <- read_csv("202211-divvy-tripdata.csv")
d_202210 <- read_csv("202210-divvy-tripdata.csv")
d_202209 <- read_csv("202209-divvy-tripdata.csv")
d_202208 <- read_csv("202208-divvy-tripdata.csv")
d_202207 <- read_csv("202207-divvy-tripdata.csv")
d_202206 <- read_csv("202206-divvy-tripdata.csv")
d_202205 <- read_csv("202205-divvy-tripdata.csv")
d_202204 <- read_csv("202204-divvy-tripdata.csv")

# Check datasets consistency
colnames(d_202303)
colnames(d_202302)
colnames(d_202301)
colnames(d_202212)
colnames(d_202211)
colnames(d_202210)
colnames(d_202209)
colnames(d_202208)
colnames(d_202207)
colnames(d_202206)
colnames(d_202205)
colnames(d_202204)

# All columns have equal names
# Double check and inspect data frames for incongruities

str(d_202303)
str(d_202302)
str(d_202301)
str(d_202212)
str(d_202211)
str(d_202210)
str(d_202209)
str(d_202208)
str(d_202207)
str(d_202206)
str(d_202205)
str(d_202204)

# All data is consistent

# Stack the individual last 12 months data frames into one big data frame
all_trips <- bind_rows(d_202303,d_202302,d_202301,d_202212,d_202211,d_202210,d_202209,d_202208, d_202207,d_202206,d_202205,d_202204)

# Inspecting the new table created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# Check missing values and duplicates
colSums(is.na(all_trips))
sum(duplicated(all_trips$ride_id))

#Check if terms are correct
table(all_trips$member_casual)

# Adding columns that list the date, month, day, and year of each ride
all_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Calculating and adding the "ride_length" in seconds
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

str(all_trips)

# Calculated field is in time difference format "# seconds"... so it´s necessary to convert it to a standard numeric format
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# Observations:
  # 1. The dataframe includes entries where ride_length is negative
  # 2. The dataframe includes entries where the bikes where taken to "HQ QR" for quality control
  # 3. end_station and start_station columns have NA values

# It´s necessary to remove the data mention above (as it´s not representative of the users or it's incomplete)
all_trips_v2 <- all_trips %>%
  filter(!is.na(start_station_name),!is.na(end_station_name), start_station_name != "HQ QR", ride_length > 0)

# Because of my computer system the column "day_of_week" is in Portuguese (PT), so it´s necessary to take a additional step to translate it to english
all_trips_v2 <- all_trips_v2 %>%
  mutate(day_of_week = case_when(
    day_of_week == "segunda-feira" ~ "Monday",
    day_of_week == "terça-feira" ~ "Tuesday",
    day_of_week == "quarta-feira" ~ "Wednesday",
    day_of_week == "quinta-feira" ~ "Thursday",
    day_of_week == "sexta-feira" ~ "Friday",
    day_of_week == "sábado" ~ "Saturday",
    day_of_week == "domingo" ~ "Sunday",
    TRUE ~ day_of_week
  ))

# Descriptive analysis on ride_length
summary(all_trips_v2$ride_length)

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

# Let's visualize the number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)



####


#remove columns not needed: start_station_id, end_station_id, start_lat, start_long, end_lat, end_lng
cyclistic_data <- all_trips_v2 %>% 
  select(-ride_id, -start_station_id, -end_station_id, -started_at, -ended_at)

names(all_trips_v2)

colSums(is.na(cyclistic_data))

write.csv(all_trips_v2, "C:/Users/rafa_/OneDrive/Área de Trabalho/Case Study DA/all_data.csv", row.names = FALSE)
write.csv(counts, "C:/Users/rafa_/OneDrive/Área de Trabalho/Case Study DA/data_counts.csv", row.names = FALSE)
write.csv(cyclistic_data, "C:/Users/rafa_/OneDrive/Área de Trabalho/Case Study DA/cyclistic_data.csv", row.names = FALSE)
