# Forest-Fire-Prediction-with-R

![image](https://github.com/user-attachments/assets/c8a21fe4-9bb9-4c14-9305-ecbfb404c5d5)


## 1 Background and Introduction
Forest fires are a major concern across the world, causing cities to evacuate, filling the air with smoke, and inflicting costly damage to natural resources. To keep fire-fighting resources appropriately prepared and people living within the reach of potential fires safely informed, high-risk fire areas/conditions must be identified. If the total area affected by a potential fire could be predicted based on weather conditions, then fire-fighting resources would be better prepared to anticipate and mitigate the impact of a fire.
This analysis will attempt to determine if an area affected by a fire can be predicted by the average temperature on a certain day. Our hypothesis is that fires on hotter days will be associated with larger damaged areas. For this analysis, we will only be considering fires that affect larger than 1 hectare (10,000 square meters, or roughly less than 2 football fields) of area but less than 100 hectares. Fires that affect less than 1 hectare won't require many resources to fight and won't impact as much of a community, and fires larger than 100 hectares are rarer and would require more data than temperature to predict with any accuracy, as well as require more resources than most individual communities are equipped with to fight.
### 1.1 Business Objectives
To Predict the burned area of forest fires in the northeast region of Portugal using meteorological data. This prediction would help forest management agencies allocate resources, plan fire prevention strategies, and estimate the impact of potential fires.
### 1.2 Business Question
"Can we accurately predict the extent of forest fire damage based on weather and spatial factors?"
"Can we extrapolate the study and apply the lessons to regions with similar climate conditions to the study?"
### 1.3 Description of the Dataset
•	X: X-axis spatial coordinate within the Montesinho park map: 1 to 9
•	Y: Y-axis spatial coordinate within the Montesinho park map: 2 to 9
•	month: Month of the year: 'jan' to 'dec'
•	day: Day of the week: 'mon' to 'sun'
•	FFMC: Fine Fuel Moisture Code index from the FWI system: 18.7 to 96.20
•	DMC: Duff Moisture Code index from the FWI system: 1.1 to 291.3
•	DC: Drought Code index from the FWI system: 7.9 to 860.6
•	ISI: Initial Spread Index from the FWI system: 0.0 to 56.10
•	temp: Temperature in Celsius degrees: 2.2 to 33.30
•	RH: Relative humidity in percentage: 15.0 to 100
•	wind: Wind speed in km/h: 0.40 to 9.40
•	rain: Outside rain in mm/m2 : 0.0 to 6.4
•	area: The burned area of the forest (in ha): 0.00 to 1090.84

## Part 2: Exploratory Data Analysis
In this section I will perform an EDA on the forest fire dataset and note down the results.
### 2.1 Overview of the Dataset
Importing the csv file of the dataset into a variable called “fire_data” in R, using the code:

fire_data <- read.csv("D:\\Study\\forestfires.csv")
