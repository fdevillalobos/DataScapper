———————————————————————————————————————————————————————————— 
——————————————————Francisco de Villalobos——————————————————— 
———————————————————————————————————————————————————————————— 

———————————————————————————————————————————————————————————— 
——————————————————Part I - Java to Ruby-———————————————————— 
————————————————————————————————————————————————————————————
Files: friends.txt, friend_tracker.rb, person.rb, FriendProgram.java, FriendTracker.java, Person.java

I here used a program that Swap provided me as I have never implemented anything in Java, and most of my programming exercises involve timers, inputs and outputs, sensor… as I’m a master in Robotics.

The code is supposed to upload a list of persons and their friends, and create Persons in a people array. The array has Person objects in it.
There are methods for finding if a certain name is in the uploaded list, to load the file from a .txt, to see who is the one that has the most friends, to check how many friends in common two people have, to check of the existence of a person in a people array, and finally, to suggest a friend to a certain person.

This method using some of the past ones, it check all your friends friends… and check who is the one that is most repeated among them. It them suggest that person as your new friend.

It also has a person class file where all the settings for persons are provided.

Swap told me that this files should be enough for the complexity of this project.


———————————————————————————————————————————————————————————— 
—————Part II - CIA World Factbook Data Scapping Project—————
————————————————————————————————————————————————————————————
Files: country.rb, main.rb, README.txt

I must first clarify that I used the low-bandwidth version of the World Factbook site.

General Code Comments:
I tried and designed this code so that is as efficient as possible.
It will only connect one time (as soon as you run it) to the World Factbook Website, and get everything it will need to answer not only this questions, but any question we can ask it.
I then thought about doing a tiny def for every piece of information that I needed… because style guidelines say that def’s should be compact… but it seemed very inefficient to have to do .select or .map that many times when you can go through every country just once and take all the information that you need.

It will then run one time an information gathering in all the presented code, and finally it will be ready for any questions we would like to ask it. I did this because if not, every time you ask for a question, it has to go over all the countries and I thought it would be more time inefficient.


———————————————————————————————————————————————————————————— 
names, country = initial_load
Needs no arguments.
Returns as first argument an Array with all the country names.
Returns as a second argument, a Hash with all the information of all the countries in it.


———————————————————————————————————————————————————————————— 
country = vlook_information(names, country)
Needs both outputs of the initial_load function.
names = Array with all the country names.
country = Hash with all the information of all the countries in it.

Returns country = Hash with all the information of all the countries in it. (Updated with new information)



———————————————————————————————————————————————————————————— 
Question #1
List countries in @continent that are prone to @disasters.

Method call:
question_1(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
continent: Array  —> [‘South America’, ‘Asia’], [‘Oceania’]
disaster:  Array  —> [‘earthquake’, ‘flood’], [‘tornado’]
note: Even if you pass one continent it should be inside of an Array as [“continent”]
note 2: Pass the disaster as singulars and not as plurals. flood will work but floods will leave some out.

examples: question_1(country, continent: [“South America”, “North America”, “Europe”], disaster: [“earthquake”])

Method “iterates” though each continent, then disaster and then country. For each county it checks if it’s in the continent and if it has disaster occurrences. If so, it prints it.
I used select and map here, but didn’t know how to replace both each loops that still remain.


———————————————————————————————————————————————————————————— 
Question #2
List the first @number countries in @continent that have the highest/lowest geographic points.

Method call:
question_2(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
continent: String
limit:  boolean —>  1 for highest points, 0 for lowest.
number: integer —>  Number of countries to return

examples: question_2(country, continent: “South America”, limit: 0, number: 3)
note: because I could not eliminate the each loop on question_1 and because it was not required, I did not make this one to accept multiple continents though it would be very easy to implement.

Method check if the country belongs to the continent, and then it sorts all the ones that remain to get the highest or lowest of them.



———————————————————————————————————————————————————————————— 
Question #3
List all the countries that belong to a certain quadrant/hemisphere of the earth.

Method call:
question_3(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
longitude: String —>  ’S’ or ’N’
latitude:  String —>  ‘E’ or ‘W’

examples: question_3(country, longitude: ’N’, latitude: ‘W’)

Method checks in the coordinates of the country if it belongs to a certain quadrant.



———————————————————————————————————————————————————————————— 
Question #4
List all the countries that have more than @min number of political parties.

Method call:
question_4(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
continent: String —>  ‘South America’, ‘Asia’, ‘Oceania’, etc.
min: integer      —>  Minimum number of parties.

examples: question_4(country, continent: ‘Asia’, min: 12)

Method selects the countries that belong to a certain country and have a minimum of a certain number of political parties.

Assumptions: Pressure groups were not counted, and I took care for as many different scenarios that presented themselves, but some of the countries I know don’t return the correct value because there were so many different syntaxes that it was just impossible. Swap told me this should be fine.



———————————————————————————————————————————————————————————— 
Question #5
List the top @num counties that have the highest electric consumption per capita.

Method call:
question_5(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
num: integer  —>   Number of countries to return

examples: question_5(country, num: 12)

Method sorts all the countries by consumption per capita (Previously calculated in vlook_information) and returns the top @num



———————————————————————————————————————————————————————————— 
Question #6
List the countries with a higher predominant religion than @h_limit % and lower than @l_limit

Method call:
question_6(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
low:  integer  —>   Lower percentage limit
high: integer  —>   Higher percentage limit

examples: question_6(country, low: 35, high: 90)

Method selects the countries that have a predominant religion in the specified limits.

Assumptions: Countries that did not list a certain percentage on their religions were taken as 100% for the first one that appeared. The reason for this is that I saw that most times, the ones that did not have percentages also had only one religion listed. And if not… it was those countries that have a very large number of the first one.
I talked to Swap about this and he told me that as long as I state my assumptions that shouldn’t be a problem.



———————————————————————————————————————————————————————————— 
Question #7
List landlocked countries that have less than @neighbors neighbors.

Method call:
question_7(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
neighbors:  integer  —>   Maximum number of neighbors

examples: question_7(country, neighbors: 2)

Methods check that the country is landlocked and has less than @neighbors.


———————————————————————————————————————————————————————————— 
Question #8
Which of these continents has the greatest GDP per capita?

Method call:
question_8(country, options{})
country is hash output from vlook_information
List of Acceptable options{}:
continent:  Array  —>   [‘South America’, ‘Asia’], [‘Oceania’]
note: Even if you pass one continent it should be inside of an Array as [“continent”]

examples: question_7(country, continent: [‘Asia’, ‘Oceania’, ‘Africa’])

Method gets the GDP per capita of every country in a continent, then multiplies by the population of the same, and gets the GDP and population of each country. It then groups all that by continent and calculates the GDP per capita of the continent.





———————————————————————————————————————————————————————————— 
——————————————————————————ANSWERS——————————————————————————— 
———————————————————————————————————————————————————————————— 

Question 1: Countries in ["South America"] with risk of ["earthquake"]

Argentina is in South America and it's prone to earthquakes
Chile is in South America and it's prone to earthquakes
Colombia is in South America and it's prone to earthquakes
Ecuador is in South America and it's prone to earthquakes
Peru is in South America and it's prone to earthquakes

————————————————————————————————————————————————————————————
Question 2: Country/ies in Europe with the lowest elevation point

The country is Europe that has the #1 lowest point is Denmark. It's lowest elevation is of -7 m
The country is Europe that has the #2 lowest point is Netherlands. It's lowest elevation is of -7 m

————————————————————————————————————————————————————————————
Question 3: The countries that are in the SE hemisphere are:

Angola
Antarctica
Ashmore and Cartier Islands
Australia
Botswana
Bouvet Island
British Indian Ocean Territory
Burundi
Christmas Island
Cocos (Keeling) Islands
Comoros
Congo, Republic of the
Coral Sea Islands
Fiji
Gabon
Heard Island and McDonald Islands
Indian Ocean
Indonesia
Lesotho
Madagascar
Malawi
Mauritius
Mozambique
Namibia
Nauru
New Caledonia
New Zealand
Norfolk Island
Papua New Guinea
Rwanda
Seychelles
Solomon Islands
South Africa
Southern Ocean
Swaziland
Tanzania
Timor-Leste
Tuvalu
Vanuatu
Zambia
Zimbabwe

————————————————————————————————————————————————————————————
Question 4: Country in Asia with more than 10 political parties

Afghanistan is in Asia and has 84 political parties.
Azerbaijan is in Asia and has 16 political parties.
Georgia is in Asia and has 18 political parties.
Hong Kong is in Asia and has 17 political parties.
India is in Asia and has 18 political parties.
Iraq is in Asia and has 31 political parties.
Israel is in Asia and has 15 political parties.
Jordan is in Asia and has 37 political parties.
Kazakhstan is in Asia and has 12 political parties.
Lebanon is in Asia and has 18 political parties.
Malaysia is in Asia and has 20 political parties.
Maldives is in Asia and has 18 political parties.
Nepal is in Asia and has 36 political parties.
Pakistan is in Asia and has 22 political parties.
Syria is in Asia and has 23 political parties.
Thailand is in Asia and has 11 political parties.
Turkey is in Asia and has 11 political parties.

————————————————————————————————————————————————————————————
Question 5: Top 5 countries in with the greatest electric consumption per capita

Iceland has the 1 electric consumption per capita with 47887.44 kWh/inhabitant
Norway has the 2 electric consumption per capita with 23293.45 kWh/inhabitant
Kuwait has the 3 electric consumption per capita with 15968.81 kWh/inhabitant
Finland has the 4 electric consumption per capita with 14634.32 kWh/inhabitant
Canada has the 5 electric consumption per capita with 14580.10 kWh/inhabitant

————————————————————————————————————————————————————————————
Question 6: Countries with predominant religion > 80 % or < 50 %

Algeria has a predominant religion, with 99.0 % of the poputation.
Andorra has a predominant religion, with 100 % of the poputation.
Anguilla has a predominant religion, with 83.1 % of the poputation.
Argentina has a predominant religion, with 92.0 % of the poputation.
Armenia has a predominant religion, with 94.7 % of the poputation.
Aruba has a predominant religion, with 80.8 % of the poputation.
Azerbaijan has a predominant religion, with 93.4 % of the poputation.
Bahrain has a predominant religion, with 81.2 % of the poputation.
Bangladesh has a predominant religion, with 89.5 % of the poputation.
Bolivia has a predominant religion, with 95.0 % of the poputation.
British Virgin Islands has a predominant religion, with 84.0 % of the poputation.
Burma has a predominant religion, with 89.0 % of the poputation.
Burundi has a predominant religion, with 82.8 % of the poputation.
Cabo Verde has a predominant religion, with 100 % of the poputation.
Cambodia has a predominant religion, with 96.4 % of the poputation.
China has a predominant religion, with 100 % of the poputation.
Colombia has a predominant religion, with 90.0 % of the poputation.
Comoros has a predominant religion, with 98.0 % of the poputation.
Croatia has a predominant religion, with 87.8 % of the poputation.
Cuba has a predominant religion, with 85.0 % of the poputation.
Curacao has a predominant religion, with 80.1 % of the poputation.
Denmark has a predominant religion, with 95.0 % of the poputation.
Djibouti has a predominant religion, with 94.0 % of the poputation.
Dominican Republic has a predominant religion, with 95.0 % of the poputation.
Ecuador has a predominant religion, with 95.0 % of the poputation.
Egypt has a predominant religion, with 90.0 % of the poputation.
Equatorial Guinea has a predominant religion, with 100 % of the poputation.
Eritrea has a predominant religion, with 100 % of the poputation.
Faroe Islands has a predominant religion, with 83.8 % of the poputation.
Finland has a predominant religion, with 82.5 % of the poputation.
France has a predominant religion, with 83.0 % of the poputation.
Gambia, The has a predominant religion, with 90.0 % of the poputation.
Gaza Strip has a predominant religion, with 99.3 % of the poputation.
Georgia has a predominant religion, with 83.9 % of the poputation.
Greece has a predominant religion, with 98.0 % of the poputation.
Greenland has a predominant religion, with 100 % of the poputation.
Guam has a predominant religion, with 85.0 % of the poputation.
Guatemala has a predominant religion, with 100 % of the poputation.
Guernsey has a predominant religion, with 100 % of the poputation.
Guinea has a predominant religion, with 85.0 % of the poputation.
Holy See (Vatican City) has a predominant religion, with 100 % of the poputation.
Honduras has a predominant religion, with 97.0 % of the poputation.
Hong Kong has a predominant religion, with 90.0 % of the poputation.
Iceland has a predominant religion, with 80.7 % of the poputation.
India has a predominant religion, with 80.5 % of the poputation.
Indonesia has a predominant religion, with 86.1 % of the poputation.
Iran has a predominant religion, with 98.0 % of the poputation.
Iraq has a predominant religion, with 97.0 % of the poputation.
Ireland has a predominant religion, with 87.4 % of the poputation.
Isle of Man has a predominant religion, with 100 % of the poputation.
Japan has a predominant religion, with 83.9 % of the poputation.
Jersey has a predominant religion, with 100 % of the poputation.
Jordan has a predominant religion, with 92.0 % of the poputation.
Kenya has a predominant religion, with 82.5 % of the poputation.
Korea, North has a predominant religion, with 100 % of the poputation.
Kosovo has a predominant religion, with 100 % of the poputation.
Kuwait has a predominant religion, with 85.0 % of the poputation.
Liberia has a predominant religion, with 85.6 % of the poputation.
Libya has a predominant religion, with 97.0 % of the poputation.
Luxembourg has a predominant religion, with 87.0 % of the poputation.
Malawi has a predominant religion, with 82.7 % of the poputation.
Maldives has a predominant religion, with 100 % of the poputation.
Mali has a predominant religion, with 94.8 % of the poputation.
Malta has a predominant religion, with 98.0 % of the poputation.
Mauritania has a predominant religion, with 100.0 % of the poputation.
Mexico has a predominant religion, with 82.7 % of the poputation.
Moldova has a predominant religion, with 98.0 % of the poputation.
Monaco has a predominant religion, with 90.0 % of the poputation.
Montserrat has a predominant religion, with 100 % of the poputation.
Morocco has a predominant religion, with 99.0 % of the poputation.
Nepal has a predominant religion, with 80.6 % of the poputation.
Northern Mariana Islands has a predominant religion, with 100 % of the poputation.
Norway has a predominant religion, with 85.7 % of the poputation.
Pakistan has a predominant religion, with 96.4 % of the poputation.
Panama has a predominant religion, with 85.0 % of the poputation.
Paraguay has a predominant religion, with 89.6 % of the poputation.
Peru has a predominant religion, with 81.3 % of the poputation.
Philippines has a predominant religion, with 82.9 % of the poputation.
Pitcairn Islands has a predominant religion, with 100.0 % of the poputation.
Poland has a predominant religion, with 89.8 % of the poputation.
Portugal has a predominant religion, with 84.5 % of the poputation.
Puerto Rico has a predominant religion, with 85.0 % of the poputation.
Romania has a predominant religion, with 86.8 % of the poputation.
Saint Barthelemy has a predominant religion, with 100 % of the poputation.
Saint Helena, Ascension, and Tristan da Cunha has a predominant religion, with 100 % of the poputation.
Saint Kitts and Nevis has a predominant religion, with 100 % of the poputation.
Saint Martin has a predominant religion, with 100 % of the poputation.
Saint Pierre and Miquelon has a predominant religion, with 99.0 % of the poputation.
San Marino has a predominant religion, with 100 % of the poputation.
Saudi Arabia has a predominant religion, with 100.0 % of the poputation.
Senegal has a predominant religion, with 94.0 % of the poputation.
Serbia has a predominant religion, with 85.0 % of the poputation.
Seychelles has a predominant religion, with 82.3 % of the poputation.
Somalia has a predominant religion, with 100 % of the poputation.
South Sudan has a predominant religion, with 100 % of the poputation.
Spain has a predominant religion, with 94.0 % of the poputation.
Sudan has a predominant religion, with 100 % of the poputation.
Sweden has a predominant religion, with 87.0 % of the poputation.
Taiwan has a predominant religion, with 93.0 % of the poputation.
Tajikistan has a predominant religion, with 85.0 % of the poputation.
Thailand has a predominant religion, with 94.6 % of the poputation.
Timor-Leste has a predominant religion, with 98.0 % of the poputation.
Tonga has a predominant religion, with 100 % of the poputation.
Tunisia has a predominant religion, with 98.0 % of the poputation.
Turkey has a predominant religion, with 99.8 % of the poputation.
Turkmenistan has a predominant religion, with 89.0 % of the poputation.
Tuvalu has a predominant religion, with 98.4 % of the poputation.
United Arab Emirates has a predominant religion, with 96.0 % of the poputation.
United Kingdom has a predominant religion, with 100 % of the poputation.
Uzbekistan has a predominant religion, with 88.0 % of the poputation.
Venezuela has a predominant religion, with 96.0 % of the poputation.
Wallis and Futuna has a predominant religion, with 99.0 % of the poputation.
Western Sahara has a predominant religion, with 100 % of the poputation.
Yemen has a predominant religion, with 100 % of the poputation.
Zimbabwe has a predominant religion, with 100 % of the poputation.
European Union has a predominant religion, with 100 % of the poputation.
World has a predominant religion, with 33.39 % of the poputation.
Akrotiri has a predominant religion, with 0 % of the poputation.
Angola has a predominant religion, with 47.0 % of the poputation.
Antarctica has a predominant religion, with 0 % of the poputation.
Arctic Ocean has a predominant religion, with 0 % of the poputation.
Ashmore and Cartier Islands has a predominant religion, with 0 % of the poputation.
Atlantic Ocean has a predominant religion, with 0 % of the poputation.
Australia has a predominant religion, with 27.4 % of the poputation.
Baker Island has a predominant religion, with 0 % of the poputation.
Belize has a predominant religion, with 39.3 % of the poputation.
Benin has a predominant religion, with 27.1 % of the poputation.
Bermuda has a predominant religion, with 49.2 % of the poputation.
Bosnia and Herzegovina has a predominant religion, with 40.0 % of the poputation.
Bouvet Island has a predominant religion, with 0 % of the poputation.
British Indian Ocean Territory has a predominant religion, with 0 % of the poputation.
Cameroon has a predominant religion, with 40.0 % of the poputation.
Canada has a predominant religion, with 42.6 % of the poputation.
Central African Republic has a predominant religion, with 35.0 % of the poputation.
Christmas Island has a predominant religion, with 36.0 % of the poputation.
Clipperton Island has a predominant religion, with 0 % of the poputation.
Coral Sea Islands has a predominant religion, with 0 % of the poputation.
Cote d'Ivoire has a predominant religion, with 38.6 % of the poputation.
Czech Republic has a predominant religion, with 10.3 % of the poputation.
Dhekelia has a predominant religion, with 0 % of the poputation.
Estonia has a predominant religion, with 13.6 % of the poputation.
Ethiopia has a predominant religion, with 43.5 % of the poputation.
French Southern and Antarctic Lands has a predominant religion, with 0 % of the poputation.
Germany has a predominant religion, with 34.0 % of the poputation.
Guyana has a predominant religion, with 30.5 % of the poputation.
Heard Island and McDonald Islands has a predominant religion, with 0 % of the poputation.
Howland Island has a predominant religion, with 0 % of the poputation.
Indian Ocean has a predominant religion, with 0 % of the poputation.
Jan Mayen has a predominant religion, with 0 % of the poputation.
Jarvis Island has a predominant religion, with 0 % of the poputation.
Johnston Atoll has a predominant religion, with 0 % of the poputation.
Kingman Reef has a predominant religion, with 0 % of the poputation.
Korea, South has a predominant religion, with 31.6 % of the poputation.
Latvia has a predominant religion, with 19.6 % of the poputation.
Mauritius has a predominant religion, with 48.0 % of the poputation.
Midway Islands has a predominant religion, with 0 % of the poputation.
Mozambique has a predominant religion, with 28.4 % of the poputation.
Nauru has a predominant religion, with 45.8 % of the poputation.
Navassa Island has a predominant religion, with 0 % of the poputation.
Netherlands has a predominant religion, with 30.0 % of the poputation.
New Zealand has a predominant religion, with 38.6 % of the poputation.
Norfolk Island has a predominant religion, with 45.6 % of the poputation.
Pacific Ocean has a predominant religion, with 0 % of the poputation.
Palau has a predominant religion, with 41.6 % of the poputation.
Palmyra Atoll has a predominant religion, with 0 % of the poputation.
Papua New Guinea has a predominant religion, with 27.0 % of the poputation.
Paracel Islands has a predominant religion, with 0 % of the poputation.
Russia has a predominant religion, with 20.0 % of the poputation.
Singapore has a predominant religion, with 42.5 % of the poputation.
Sint Maarten has a predominant religion, with 39.0 % of the poputation.
South Africa has a predominant religion, with 36.6 % of the poputation.
Southern Ocean has a predominant religion, with 0 % of the poputation.
South Georgia and South Sandwich Islands has a predominant religion, with 0 % of the poputation.
Spratly Islands has a predominant religion, with 0 % of the poputation.
Suriname has a predominant religion, with 27.4 % of the poputation.
Svalbard has a predominant religion, with 0 % of the poputation.
Swaziland has a predominant religion, with 40.0 % of the poputation.
Switzerland has a predominant religion, with 41.8 % of the poputation.
Tanzania has a predominant religion, with 30.0 % of the poputation.
Togo has a predominant religion, with 29.0 % of the poputation.
Trinidad and Tobago has a predominant religion, with 26.0 % of the poputation.
Uganda has a predominant religion, with 41.9 % of the poputation.
United States Pacific Island Wildlife Refuges has a predominant religion, with 0 % of the poputation.
Uruguay has a predominant religion, with 47.1 % of the poputation.
Vietnam has a predominant religion, with 9.3 % of the poputation.
Wake Island has a predominant religion, with 0 % of the poputation.

————————————————————————————————————————————————————————————
Question 7: Landlocked countries with a maximum of 1 neighbor

Holy See (Vatican City) is a landlocked country, with only 1 neighbors.
Lesotho is a landlocked country, with only 1 neighbors.
San Marino is a landlocked country, with only 1 neighbors.

————————————————————————————————————————————————————————————
Question 8: Continent in ["South America", "Central America", "North America", "Europe", "Asia", "Africa", "Oceania"] with the greatest GDP per capita

North America has the greatest accumulated GDP per capita, with: $41439.53







