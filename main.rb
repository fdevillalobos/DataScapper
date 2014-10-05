# Lite version of the site. Low-Bandwidth Version.

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './country'

# Loads all the HTML code and country list.
# Creates each country and associates it with a link and an HTML file.
def initial_load
  country = {}                                                                                                          # Initialize Hash instead of [] array.
  names = []                                                                                                            # Initialize list of country names.
  page = 'https://www.cia.gov/library/publications/the-world-factbook/print/textversion.html'                           # Website we want to access.
  index_page = Nokogiri::HTML(open(page))
  countries_html = index_page.css('div#demo li a')                                                                      # Retrieve the part where all the countries are listed.

  puts 'Getting information for the CIA. Please wait a moment...'
  countries_html.each_with_index do |link, index|
    comp_link = link.values[0]                                                                                          # Get complementary part of the link to access specific country.
    country_html = "https://www.cia.gov/library/publications/the-world-factbook/#{comp_link[3..-1]}"                    # Build country HTML.
    country[link.text.strip] = Country.new(link.text.strip, link: link.values,                                          # Add country key to hash, with some initialized parameters.
                                                            HTML: Nokogiri::HTML(open(country_html)))
    names[index] = link.text.strip                                                                                      # Add country name to the name list.
  end
  puts 'Finished Loading all Countries!'
  return names, country
end

# Looks for the necessary information to answer nearly all the questions
def vlook_information(names, country)
  puts 'Getting vital information from all the countries. Please wait a moment...'
  names.each do |ctry_name|

    # Get country coordinates
    if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[1]
      coordinates = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data')[1].text
      country[ctry_name].longitude = coordinates[/\d{1,3} \d{2} (N|S)/, 0] if coordinates[/\d{1,3} \d{2} (N|S)/, 0]
      country[ctry_name].latitude  = coordinates[/\d{1,3} \d{2} (W|E)/, 0] if coordinates[/\d{1,3} \d{2} (W|E)/, 0]
    end

    # Get continent of the country
    country[ctry_name].continent = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data a').text
    country[ctry_name].continent = case country[ctry_name].continent
      when 'Middle East'
        'Asia'
      when 'Central America and the Caribbean'
        'Central America'
      when 'Southeast Asia'
        'Asia'
      else
        country[ctry_name].continent
    end
    country['World'].continent = ' '
    country['France'].continent = 'Europe'

    # Retrieve Elevation Info - Lowest Point
    country[ctry_name].low_elev = 0
    elevations = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category')
    if elevations.text =~ (/lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m/)
      low_e = elevations.text[/lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m/, 0][/-*\d{1,2},\d{1,3}|-*\d{1,3}/, 0]       # This notation replaces .match and never gives and error, just nil.
      low_e = low_e.split(',')
      country[ctry_name].low_elev = case low_e.size
      when 1
        low_e[0].to_i
      when 2
        if low_e[0].to_i < 0
          low_e[0].to_i * 1000 - low_e[1].to_i
        else
          low_e[0].to_i * 1000 + low_e[1].to_i
        end
      end
    end

    # Retrieve Elevation Info - Highest Point
    country[ctry_name].high_elev = 0
    if elevations.text =~ (/highest point:\n*\t*\n*\t*.*\d{1,2},\d{1,3} m|highest point:\n*\t*\n*\t*.*\d{1,3} m/)
      high_e = elevations.text[/highest point:\n*\t*\n*\t*.*\d{1,2},\d{1,3} m|highest point:\n*\t*\n*\t*.*\d{1,3} m/, 0][/-*\d{1,2},\d{1,3}|-*\d{1,3}/, 0]
      high_e = high_e.split(',')
      country[ctry_name].high_elev = case high_e.size
      when 1
        high_e[0].to_i
      when 2
        if high_e[0].to_i < 0
          high_e[0].to_i * 1000 - high_e[1].to_i
        else
          high_e[0].to_i * 1000 + high_e[1].to_i
        end
      end
    end

    # Search For Political Parties - NON-GREEDY
    count = 0
    political_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Govt').inner_html[/title="Notes and Definitions: Political parties and leaders".*?(<tr class=\"mde_light\>"|note:|Political pressure groups)/m, 0]
    if political_html
      parties_html = political_html.scan(/category_data.*?div>/)
      count += parties_html.size
       parties_html.each do |str|
         count += str[/\d{1,3}/, 0].to_i - 1 if str =~ /\d{1,3} political parties/
       end
      if political_html =~ /note:/ && count > 0
        count -= 1
      end
    end
    country[ctry_name].p_party_num = count
    #puts "#{country[ctry_name].name} has #{country[ctry_name].p_party_num} political parties"

    # Get the population of the country
    population_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_People').inner_html[/title="Notes and Definitions: Population".*?<span/m, 0]
    if population_html && population_html =~ (/\d{0,3},*\d{0,3},*\d{0,3},*\d{3}/)
      population = population_html[/\d{0,3},*\d{0,3},*\d{0,3},*\d{3}/, 0].split(',')
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
    else
      country[ctry_name].population = 0
    end

    # Getting energy consumption of the country
    e_consumption_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Energy').inner_html[/title="Notes and Definitions: Electricity - consumption".*?(<span)/m, 0]
    if e_consumption_html
      e_consumption = e_consumption_html[/\d{1,3}.\d{0,3} (billion|trillion|kWh|million)/, 0].split(' ')
      country[ctry_name].elec_consumption = case e_consumption[1]
        when 'kWh'
          e_consumption[0].to_i
        when 'million'
          number = e_consumption[0].split('.')
          number[0].to_i * 1_000_000 + number[1].to_i * 1_000
        when 'billion'
          number = e_consumption[0].split('.')
          number[0].to_i * 1_000_000_000 + number[1].to_i * 1_000_000
        when 'trillion'
          number = e_consumption[0].split('.')
          number[0].to_i * 1_000_000_000_000 + number[1].to_i * 1_000_000_000
      else
        0
      end
    else
      country[ctry_name].elec_consumption = 0
    end

    # Getting dominant religion of the country
    religion_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_People').inner_html[/title="Notes and Definitions: Religions".*?(title="Notes and Definitions: Population"|,)/m, 0]
    if religion_html
      if religion_html =~ (/\d{1,2}\.{0,1}\d{0,2}%/)
        country[ctry_name].r_percentage = religion_html[/\d{1,2}\.{0,1}\d{0,2}%/, 0][0..-2].to_f
      else
        # religion = religion_html[0].match(/Roman Catholic|Daoist|Muslim|Lutheran|Protestant|Buddhist|Anglican|animist|Christian/)[0]
        country[ctry_name].r_percentage = 100
      end
    else
      country[ctry_name].r_percentage = 0
    end

    # Getting landlocked countries and neighbors
    country[ctry_name].landlocked = 0
    maritime_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo').inner_html[/title="Notes and Definitions: Coastline".*?(title="Notes and Definitions: Maritime claims"|landlocked)/m, 0]
    if maritime_html
      country[ctry_name].landlocked = 1 if maritime_html =~ (/landlocked/)
    end

    # Number of neighbors
    neighbors_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo').inner_html[/title="Notes and Definitions: Land boundaries".*?title="Notes and Definitions: Coastline"/m, 0]
    if neighbors_html
      neighbors_html = neighbors_html[/border countries:.*div>/m, 0]
      neighbors_html ?
          country[ctry_name].neighbors = neighbors_html.scan(/\d{0,3},*\d{1,3} km/).size :
          country[ctry_name].neighbors = 0
    else
      country[ctry_name].neighbors = 0
    end

    # GPD per capita
          country[ctry_name].gdp_pc = 0
    gdppc_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Econ').inner_html[/title="Notes and Definitions: GDP - per capita \(PPP\)".*?<span/m, 0]
    if gdppc_html
      if gdppc_html.scan(/\$\d{0,3},*\d{1,3}/).size > 0
        get_number = gdppc_html.scan(/\$\d{0,3},*\d{1,3}/)[0][1..-1].split(',')
        (get_number.size > 1) ?
            country[ctry_name].gdp_pc = (get_number[0]<<get_number[1]).to_i :                                           # Operation if TRUE
            country[ctry_name].gdp_pc = get_number[0].to_i                                                              # Operation if FALSE
      end
    end

  end   # Of the initial names.each!!!
  puts 'Finisehd getting information!'
  country
end

# ############################################### Question Answers ######################################################
# #######################################################################################################################
# Countries with disasters in Continents.
def question_1(country, options = {})
  @continent = options[:continent] || ['South America']
  @disaster  = options[:disaster]  || ['earthquake']

  puts ''
  puts "Question 1: Countries in #{@continent} with risk of #{@disaster}"
  @continent.each do |continent|
    puts ''
    @disaster.each do |disaster|
    ctries_continent = country.select { |ctry, hash| hash.continent == continent }
    ctries_disaster  = ctries_continent.select { |ctry, hash| hash.HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').text =~ /#{disaster}/ }
    ctries_disaster.map { |ctry, hash| puts "#{hash.name} is in #{hash.continent} and it's prone to #{disaster}s"}
    end
  end
  nil
end

# Elevation Comparisson in Continent
def question_2(country, options = {})
  @continent = options[:continent] || 'Europe'
  @limit  = options[:limit]  || 0      # 0 For lowest point. 1 for highest point.
  @number = options[:number] || 2     # Get more than one peak
  pos = 0

  puts ''
  puts "Question 2: Country/ies in #{@continent} with the #{'highest' if @limit == 1}#{'lowest' if @limit == 0} elevation point"

  # Look for the highest elevation point in @continent
  ctries_continent = country.select { |ctry, hash| hash.continent == @continent && hash.name != 'European Union'}
  if @limit == 1
    high_ctry = ctries_continent.sort_by { |ctry, hash| hash.high_elev }.last(@number).reverse
    high_ctry.map { |ctry, hash| pos += 1; puts "The country is #{hash.continent} that has the ##{pos} highest point is #{hash.name}. It's highest elevation is of #{hash.high_elev} m" }
  # Look for the lowest elevation point in @continent.
  else
    low_ctry = ctries_continent.sort_by { |ctry, hash| hash.low_elev }.first(@number)
    low_ctry.map { |ctry, hash| pos += 1; puts "The country is #{hash.continent} that has the ##{pos} lowest point is #{hash.name}. It's lowest elevation is of #{hash.low_elev} m" }
  end
  nil
end

# Hemisfere Queadrant Belonging
def question_3(country, options = {})
  @longitude  = options[:longitude]  || 'S'
  @latitude   = options[:latitude]   || 'E'

  puts ''
  puts "The countries that are in the #{@longitude}#{@latitude} hemisphere are:"
  ctry_hemis = country.select { |_, hash| hash.longitude =~ /#{@longitude}/ && hash.latitude =~ /#{@latitude}/}
  ctry_hemis.map { |_, hash| puts hash }
  nil
end

# Political Parties
def question_4(country, options = {})
  @continent = options[:continent] || 'Asia'
  @min_num_pp = options[:min] || 10

  puts ''
  puts "Question 4: Country in #{@continent} with more than #{@min_num_pp} political parties"
  ctry_parties = country.select { |_, hash| hash.continent == @continent && hash.p_party_num > @min_num_pp}
  ctry_parties.map { |_, hash| puts "#{hash.name} is in #{hash.continent} and has #{hash.p_party_num} political parties." }
  nil
end

# Electric Consumption per Capita
def question_5(country, options = {})
  # @continent = options[:continent] || 'Asia'
  @ctry_num = options[:num] || 5
  pos = 0

  puts ''
  puts "Question 5: Top #{@ctry_num} countries in #{@continent} with the greatest electric consumption per capita"
  ctry_list = country.sort_by { |ctry, hash| hash.c_per_capita }.last(@ctry_num).reverse
  ctry_list.map { |ctry, hash| pos += 1; puts "#{hash.name} has the #{pos} electric consumption per capita with #{'%.2f' % hash.c_per_capita} kWh/inhabitant" }
  nil
end
# #### COULD USE THIS country.sort_by{|ctry| ctry[1].c_per_capita}.last(@number)

# Predominant Religion
def question_6(country, options = {})
  @l_limit = options[:low]  || 50
  @h_limit = options[:high] || 80

  puts ''
  puts "Question 6: Countries with predominant religion > #{@h_limit} % or < #{@l_limit} %"
  high_per = country.select { |_, hash| hash.r_percentage > @h_limit }
  high_per.map { |_, hash| puts "#{hash} has a predominant religion, with #{hash.r_percentage} % of the poputation." }
  low_per = country.select { |_, hash| hash.r_percentage < @l_limit }
  low_per.map { |_, hash| puts "#{hash} has a predominant religion, with #{hash.r_percentage} % of the poputation." }
  nil
end

# Landlocked countries with X or less neighbors
def question_7(country, options = {})
  @neighbors = options[:neighbors]  || 1

  puts ''
  puts "Question 7: Landlocked countries with a maximum of #{@neighbors} neighbor#{'s' if @neighbors > 1}"
  ctry_locked = country.select { |_, hash| hash.landlocked == 1 && hash.neighbors <= @neighbors}
  ctry_locked.map { |_, hash| puts "#{hash} is a landlocked country, with only #{hash.neighbors} neighbors." }
  nil
end

# Find best sum of GDP per capita in continents. WILDCARD.
def question_8(country, options = {})
  @continent = options[:continent]  || ['South America', 'Central America', 'North America', 'Europe', 'Asia', 'Africa', 'Oceania']
  continent_gdp = Array.new(@continent.size, 0)
  continent_popu = Array.new(@continent.size, 0)
  c_gdp_per_c = Array.new(@continent.size, 0)

  puts ''
  puts "Question 8: Continent in #{@continent} with the greatest GDP per capita"
  @continent.each_with_index do |continent, index|
    ctry_continent = country.select { |_, hash| hash.continent == continent }
    ctry_continent.map { |_, hash| continent_gdp[index] += hash.gdp_pc * hash.population;
                                   continent_popu[index] += hash.population }
    c_gdp_per_c[index] = continent_gdp[index].to_f / continent_popu[index]
    #puts "#{continent} has a accumulated GDP per capita of: $#{c_gdp_per_c[index]}"
  end
  puts "#{@continent[c_gdp_per_c.index(c_gdp_per_c.max)]} has the greatest accumulated GDP per capita, with: $#{'%.2f' % c_gdp_per_c.max}"
  nil
end
# ############################################ EXECUTING CODE ######################################################

#names, country = initial_load
#country = vlook_information(names, country)
#
#question_1(names, country)
#question_2(names, country)
#question_3(names, country)
#question_4(names, country)
#question_5(country)
#question_6(names, country)
#question_7(names, country)
#question_8(names, country)
