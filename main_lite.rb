# Lite version of the site

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './country'


def initial_Load
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require './country'
	country = {};	#Hash instead of [] array.
	names = []
	page = 'https://www.cia.gov/library/publications/the-world-factbook/print/textversion.html'
	index_page = Nokogiri::HTML(open(page))
	countries_HTML = index_page.css('div#demo li a')
	#puts Countries_HTML
	
	countries_HTML.each_with_index do |link, index|
		comp_link = link.values[0]
		country_HTML = "https://www.cia.gov/library/publications/the-world-factbook/#{comp_link[3..-1]}"
		country[link.text.strip] = Country.new(link.text.strip, {
            link: link.values,
            HTML: Nokogiri::HTML(open(country_HTML))
        })
        names[index] = link.text.strip
        puts "Loaded #{link.text.strip}"		#Output the name of the countries as it loads them
	end
	return names, country
	puts "Finished Loading all Countries"
end	
	
	
#names, country = initial_Load()
	
def vlook_continent(names, country)	
	names.each do |ctry_name|
		#Noko_HTML = country[ctry_name].HTML
		
		# Get Latitudes and Longitudes
		if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[1] != nil
			coordinates = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[1].text
			country[ctry_name].longitude = coordinates.split(/, /)[0]
			country[ctry_name].latitude  = coordinates.split(/, /)[1]
		end
		
		# Get continent of the country
		country[ctry_name].continent = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data a').text
		country[ctry_name].continent = case country[ctry_name].continent
			when "Middle East"
				"Asia"
			when "Central America and the Caribbean"
				"Central America"
			when "Southeast Asia"
				"Asia"
			else
				country[ctry_name].continent
		end
		
		# Match countries in South America with countries with earthquakes.
		if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[10] != nil				#Check that you get text out of it and not a nil value.	
			disasters = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[10].text
			#puts disasters
			if disasters =~ /earthquake/
				if country[ctry_name].continent == "South America"
					country[ctry_name].disaster = "earthquakes"
					puts "#{ctry_name} is in #{country[ctry_name].continent} and it's prone to #{country[ctry_name].disaster}"
				end	
			end
			
#  			if country[ctry_name].continent == "South America" && disasters =~ /eartquake/
#  				#puts "Entro"
#  				country[ctry_name].disaster = "earthquakes"
#  				puts "#{ctry_name} is in South America and it's prone to #{country[ctry_name].disaster}"
#  			end
		end
		
		# Match European Countries with elevation info
		#country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category').text.match(/(lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m)/)[0]
		puts ctry_name
		low = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category')
		
		if low.text =~ (/(lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m)/)
				low = low.text.match(/(lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m)/)[0].match(/\d{1,2},\d{1,3}|\d{1,3}/)[0]
				country[ctry_name].low_elev = low.to_i
				puts country[ctry_name].low_elev
			#low = low.text.match(/(lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m)/)[0]
			#low = low.match(/\d{1,2},\d{1,3}|\d{1,3}/)[0]
		end
	end
	return country
end

#country = vlook_continent(names, country)	
	
	





