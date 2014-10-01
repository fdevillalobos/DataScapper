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
  country = {}; #Hash instead of [] array.
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
    puts "Loaded #{link.text.strip}"    #Output the name of the countries as it loads them
  end
  return names, country
  puts "Finished Loading all Countries"
end 
  
  
#names, country = initial_Load()
  
def vlook_information(names, country) 
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
    
    # Check for Earthquakes.
    #To make it fancier we have to create and array of disasters and the check for all of them in the question answer.
    if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').text =~ /earthquake/
      country[ctry_name].disaster = "earthquakes"
    end
    
    
    # Match European Countries with elevation info
    elevations = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category')
    if elevations.text =~ (/lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m/)
        low_e  = elevations.text.match(/lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m/)[0].match(/-*\d{1,2},\d{1,3}|-*\d{1,3}/)[0]
        low_e = low_e.split(",")
        country[ctry_name].low_elev = case low_e.size
          when 1
            low_e[0].to_i
          when 2
            if low_e[0].to_i < 0
              low_e[0].to_i * 1000 - low_e[1].to_i
            else
              low_e[0].to_i * 1000 + low_e[1].to_i
            end
          else
            "Incorrect Size"
        end
    end
    
    if elevations.text =~ (/highest point:\n*\t*\n*\t*.*\d{1,2},\d{1,3} m|highest point:\n*\t*\n*\t*.*\d{1,3} m/)
        high_e = elevations.text.match(/highest point:\n*\t*\n*\t*.*\d{1,2},\d{1,3} m|highest point:\n*\t*\n*\t*.*\d{1,3} m/)[0].match(/-*\d{1,2},\d{1,3}|-*\d{1,3}/)[0]
        high_e = high_e.split(",")
        country[ctry_name].high_elev = case high_e.size
          when 1
            high_e[0].to_i
          when 2
            if high_e[0].to_i < 0
              high_e[0].to_i * 1000 - high_e[1].to_i
            else
              high_e[0].to_i * 1000 + high_e[1].to_i
            end
          else
            "Incorrect Size"
        end
    end
    
    puts "#{ctry_name}. Lowest Point: #{country[ctry_name].low_elev}. Highest Point: #{country[ctry_name].high_elev}"
            
  end
  return country
end

#country = vlook_continent(names, country)  
  
def question_1(names, country, options = {})
  @continent = options[:continent] || "South America"
  @disaster  = options[:disaster]  || "earthquakes"
  
  names.each do |ctry_name|
    # Get countries in @continent that have earthquakes.
    if country[ctry_name].continent == @continent && country[ctry_name].disaster == @disaster
      puts "#{ctry_name} is in #{country[ctry_name].continent} and it's prone to #{country[ctry_name].disaster}"
    end
  end
  return nil
end



def question_2(names, country, options = {})
  @continent = options[:continent] || "Europe"
  @limit  = options[:limit]  || 0
  ctry_index = 0
  
  # Look for the highest elevation point in @continent
  if @limit == 1  
    max = 0
    names.each_with_index do |ctry_name, index|
      if country[ctry_name].continent == @continent && country[ctry_name].low_elev != nil && country[ctry_name].high_elev > max
        max = country[ctry_name].high_elev
        ctry_index = index
      end
    
    end
    puts "The country in #@continent that has the highest elevation is #{country[names[ctry_index]]}. It's highest elevation is of #{country[names[ctry_index]].high_elev} m"
    
  # Look for the country with the lowest highest elevation point in @continent.
  else
    min = 20000
    names.each_with_index do |ctry_name, index|
      # Get countries in @continent that have the lowest highest elevation point.
      if country[ctry_name].continent == @continent && country[ctry_name].low_elev != nil && country[ctry_name].high_elev < min
        min = country[ctry_name].high_elev
        ctry_index = index
      end
    
    end
    puts "The country in #@continent that has the lowest elevation is #{country[names[ctry_index]]}. It's highest elevation is of #{country[names[ctry_index]].high_elev} m"
  end
  
  return nil
end















