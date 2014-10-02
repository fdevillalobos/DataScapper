# Lite version of the site

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './country'

# Loads all the HTML code and country list. Creates each country and associates it with a link and an HTML file.
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
  puts "Finished Loading all Countries"
  return names, country
end 
  
  
#names, country = initial_Load()


#Looks for the necessary information to answer all the questions  
def vlook_information(names, country) 
  names.each do |ctry_name|
    
    #Get country coordinates
    if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[1] != nil
      coordinates = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[1].text
      country[ctry_name].longitude = coordinates.match(/\d{1,3} \d{2} (N|S)/)[0] if coordinates.match(/\d{1,3} \d{2} (N|S)/) != nil
      country[ctry_name].latitude  = coordinates.match(/\d{1,3} \d{2} (W|E)/)[0] if coordinates.match(/\d{1,3} \d{2} (W|E)/) != nil
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
    country["World"].continent = " "
    
    # Check for Earthquakes.
    #To make it fancier we have to create and array of disasters and the check for all of them in the question answer.
    if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').text =~ /earthquake/
      country[ctry_name].disaster = "earthquakes"
    end
    
    
    # Retrieve Elevation Info - Lowest Point
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
    
    # Retrieve Elevation Info - Highest Point
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
    #puts "#{ctry_name}. Lowest Point: #{country[ctry_name].low_elev}. Highest Point: #{country[ctry_name].high_elev}"
    
    
    # Search For Political Parties - NON-GREEDY -->  REVIEW THIS PART AGAIN
    count = 0
    political_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Govt').inner_html.match(/title="Notes and Definitions: Political parties and leaders".*?(<tr class=\"mde_light\>"|note:)/m)
    if political_html != nil
      parties_html = political_html[0].scan(/category_data.*?div>/)
      count = count + parties_html.size
#       parties_html.each do |str|
#         if str =~ /\d{1,3} political parties/
#           count =+ str.match(/\d{1,3}/)[0].to_i - 1
#         end    
#       end
      if political_html[0] =~ /note:/ && count > 0
        count = count - 1
      end
    end
    country[ctry_name].p_party_num = count
    #puts "#{ctry_name} has #{country[ctry_name].p_party_num} political parties"
    
    
    #Get the population of the country
    population_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_People').inner_html.match(/title="Notes and Definitions: Population".*?<span/m)
    if population_html != nil && population_html[0] =~ (/\d{0,3},*\d{0,3},*\d{0,3},*\d{3}/)
      population = population_html[0].match(/\d{0,3},*\d{0,3},*\d{0,3},*\d{3}/)[0].split(",")
  #    if population.size > 0
        country[ctry_name].population = case population.size
          when 1
            population[0].to_i
          when 2
            (population[0] << population[1]).to_i
          when 3
            (population[0] << population[1] << population[2]).to_i
          when 4
            (population[0] << population[1] << population[2] << population[3]).to_i
          else
            0
        end
  #    end
    else
      country[ctry_name].population = 0
    end
    
    puts "#{ctry_name} has #{country[ctry_name].population} inhabitants."
            
  end   #Of the initial names.each!!!
  puts "Finisehd!"
  return country
end

#country = vlook_continent(names, country)  



















# Countries with disasters in Continents.  
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


#Elevation Comparisson in Continent
def question_2(names, country, options = {})
  @continent = options[:continent] || "Europe"
  @limit  = options[:limit]  || 0
  ctry_index = 0
  
  # Look for the highest elevation point in @continent
  if @limit == 1  
    max = 0
    names.each_with_index do |ctry_name, index|
      if country[ctry_name].continent == @continent && country[ctry_name].high_elev != nil && country[ctry_name].high_elev > max
        max = country[ctry_name].high_elev
        ctry_index = index
      end
    
    end
    puts "The country in #@continent that has the highest elevation is #{country[names[ctry_index]]}. It's highest elevation is of #{country[names[ctry_index]].high_elev} m"
    
  # Look for the country with the lowest highest elevation point in @continent.
  else
    min = 20000
    names.each_with_index do |ctry_name, index|
      # Get countries in @continent that have the lowest elevation point.
      if country[ctry_name].continent == @continent && country[ctry_name].low_elev != nil && country[ctry_name].low_elev < min
        min = country[ctry_name].low_elev
        ctry_index = index
      end
    
    end
    puts "The country in #@continent that has the lowest elevation is #{country[names[ctry_index]]}. It's lowest elevation is of #{country[names[ctry_index]].low_elev} m"
  end
  
  return nil
end


#Hemisfere Queadrant Belonging
def question_3(names, country, options = {})
  @longitude  = options[:longitude]  || "S"
  @latitude   = options[:latitude]   || "E"
  
  puts "The countries that are in the #@longitude#@latitude hemisphere are:"
  names.each do |ctry_name|
    if country[ctry_name].longitude =~ /#@longitude/ && country[ctry_name].latitude =~ /#@latitude/
      puts country[ctry_name].name
    end
  end
  return nil
end


#Political Parties
def question_4(names, country, options = {})
  @continent = options[:continent] || "Asia"
  @min_num_pp = options[:min] || 10 
  
  names.each do |ctry_name|
    # Get countries in @continent that have more than @min_pp_num of political parties.
    if country[ctry_name].continent == @continent && country[ctry_name].p_party_num > @min_num_pp
      puts "#{country[ctry_name]} is in #{country[ctry_name].continent} and has #{country[ctry_name].p_party_num} political parties."
    end
  end
  
  return nil
end









