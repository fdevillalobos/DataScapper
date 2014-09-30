require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './country'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
#page = 'https://www.cia.gov/library/publications/the-world-factbook/'
#text_page = 'https://www.cia.gov/library/publications/the-world-factbook/print/textversion.html'
#doc = Nokogiri::HTML(open(page))
# puts doc.class
#puts doc.css('title').text


#Countries_HTML =  doc.css('div.option_table_wrapper').css('option')
#Countries_HTML.each{|link| puts "#{link.text}\t#{link['href']}"}
# CountryName = Array.new(Countries_HTML.size)
# CountryKeys = Array.new(Countries_HTML.size)

# Countries_HTML.each_with_index do |link, index|
# 	CountryName[index] = link.text.strip
# 	CountryKeys[index] = link.values
# 	#CountryContent[index] = link.content Will copy the same thing as link.text
# 	puts CountryName[index]
# 	puts CountryKeys[index]
# end


#def CountryLinks
	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require './country'

	country = {};	#Hash instead of [] array.
	names = []
	page = 'https://www.cia.gov/library/publications/the-world-factbook/'
	index_page = Nokogiri::HTML(open(page))
	Countries_HTML = index_page.css('div.option_table_wrapper').css('option')
	
	Countries_HTML.each_with_index do |link, index|
		country_HTML = "https://www.cia.gov/library/publications/the-world-factbook/#{link.values[0]}"
		country[link.text.strip] = Country.new(link.text.strip, {
            link: link.values,
            HTML: Nokogiri::HTML(open(country_HTML))
        })
        names[index] = link.text.strip
        #puts country_HTML
		#Country = link.text.strip
		#CountryKeys[index] = link.values
		#CountryContent[index] = link.content Will copy the same thing as link.text
		#puts country[link.text.strip]
	end
#end	
	puts "Finished Loading all Countries"
		#puts country["Argentina"].HTML
	#puts country["Argentina"].link



#def vlook_Continent
# 	require 'rubygems'
# 	require 'nokogiri'
# 	require 'open-uri'
# 	require './country'
# 
	names.each do |ctry_name|
		Noko_HTML = country[ctry_name].HTML
		Geo = Noko_HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').first.content
		#country[ctry_name].continent = Noko_HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').first
		# = Geo.text
		puts Geo
		puts ""
	end








#def vlook_Continent
# 	require 'rubygems'
# 	require 'nokogiri'
# 	require 'open-uri'
# 	require './country'
# 	
# 	country_location = 'https://www.cia.gov/library/publications/the-world-factbook/fields/2144.html'
# 	Continents = Nokogiri::HTML(open(country_location))
# 	
# 	country_name = Continents.css('td.fl_region a')
# 	#puts country_name[0]
# 	country_name.each do |name|
# 		ctry = name.text
# 		country[ctry].co
# 		
# 	end
	#puts country_name
#end

#vlook_Continent()

































#puts Second[0].css('value').text


# Search for nodes by css
# doc.css('h3.r a').each do |link|
# puts link.content
# end
# 
# puts "---------------------------------------"
# ####
# # Search for nodes by xpath
# doc.xpath('//h3/a').each do |link|
# puts link.content
# end
# 
# puts "---------------------------------------"
# ####
# # Or mix and match.
# doc.search('h3.r a.l', '//h3/a').each do |link|
# puts link.content
# end



#open(doc) do |site|
	#p site.status
	#p site.last_modified
	#p site.content_type
	#p site.charset
	
	#site.each_line do |line|
	#	p line
	#end
#end