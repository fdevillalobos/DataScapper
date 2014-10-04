CIA World Factbook Data Scapping Project.

I must first clarify that I used the low-bandwidth version of the World Factbook site.

General Code Comments:
I tried and designed this code so that is as efficient as possible.
It will only connect one time (as soon as you run it) to the World Factbook Website, and get everything it will need to answer not only this questions, but any question we can ask it.

It will then run one time an information gathering in all the presented code, and finally it will be ready for any questions we would like to ask it. I did this because if not, every time you ask for a question, it has to go over all the countries and I thought it would be more time inefficient.



Question #1
List countries in @continent that are prone to @disasters.

definition call:
question_1(names, country, options{})
List of Acceptable options{}:
continent: Array
disaster:  Array
examples: question_1(names, country, continent: [“South America”, “North America”, “Europe”], disaster: [“earthquake”])
note: Even if you pass one continent it should be inside of an Array as [“continent”]

Function iterates though each continent, then disaster and then country. For each county it checks if it’s in the continent and if it has disaster occurrences. If so, it prints it.

