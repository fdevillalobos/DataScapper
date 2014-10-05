———————————————————————————————————————————————————————————— 
——————————————————Francisco de Villalobos——————————————————— 
———————————————————————————————————————————————————————————— 

———————————————————————————————————————————————————————————— 
——————————————————Part I - Java to Ruby-———————————————————— 
————————————————————————————————————————————————————————————
I here used a program that Swap provided me as I have never implemented anything in Java, and most of my programming exercises involve timers, inputs and outputs, sensor… as I’m a master in Robotics.

The code is supposed to upload a list of persons and their friends, and create Persons in a people array. The array has Person objects in it.
There are methods for finding if a certain name is in the uploaded list, to load the file from a .txt, to see who is the one that has the most friends, to check how many friends in common two people have, to check of the existence of a person in a people array, and finally, to suggest a friend to a certain person.

This method using some of the past ones, it check all your friends friends… and check who is the one that is most repeated among them. It them suggest that person as your new friend.

It also has a person class file where all the settings for persons are provided.

Swap told me that this files should be enough for the complexity of this project.


———————————————————————————————————————————————————————————— 
—————Part II - CIA World Factbook Data Scapping Project—————
————————————————————————————————————————————————————————————

I must first clarify that I used the low-bandwidth version of the World Factbook site.

General Code Comments:
I tried and designed this code so that is as efficient as possible.
It will only connect one time (as soon as you run it) to the World Factbook Website, and get everything it will need to answer not only this questions, but any question we can ask it.

It will then run one time an information gathering in all the presented code, and finally it will be ready for any questions we would like to ask it. I did this because if not, every time you ask for a question, it has to go over all the countries and I thought it would be more time inefficient.


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









