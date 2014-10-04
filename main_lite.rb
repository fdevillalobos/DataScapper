# Lite version of the site. Low-Bandwidth Version.

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './country'

# Loads all the HTML code and country list.
# Creates each country and associates it with a link and an HTML file.
def initial_load
  country = {}      # Hash instead of [] array.
  names = []
  page = 'https://www.cia.gov/library/publications/the-world-factbook/print/textversion.html'
  index_page = Nokogiri::HTML(open(page))
  countries_html = index_page.css('div#demo li a')

  puts 'Getting information for the CIA. Please wait a moment...'
  countries_html.each_with_index do |link, index|
    comp_link = link.values[0]
    country_html = "https://www.cia.gov/library/publications/the-world-factbook/#{comp_link[3..-1]}"
    country[link.text.strip] = Country.new(link.text.strip, link: link.values,
                                                            HTML: Nokogiri::HTML(open(country_html)))
    names[index] = link.text.strip
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
      country[ctry_name].longitude = coordinates.match(/\d{1,3} \d{2} (N|S)/)[0] if coordinates.match(/\d{1,3} \d{2} (N|S)/)
      country[ctry_name].latitude  = coordinates.match(/\d{1,3} \d{2} (W|E)/)[0] if coordinates.match(/\d{1,3} \d{2} (W|E)/)
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

    # Check for Earthquakes.
    # To make it fancier we have to create and array of disasters and the check for all of them in the question answer.
    if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').text =~ /earthquake/
      country[ctry_name].disaster = 'earthquakes'
    end

    # Retrieve Elevation Info - Lowest Point
    elevations = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category')
    if elevations.text =~ (/lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m/)
      low_e = elevations.text.match(/lowest point:.*\d{1,2},\d{1,3} m|lowest point:.*\d{1,3} m/)[0].match(/-*\d{1,2},\d{1,3}|-*\d{1,3}/)[0]
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
        else
          'Incorrect Size'
      end
    end

    # Retrieve Elevation Info - Highest Point
    if elevations.text =~ (/highest point:\n*\t*\n*\t*.*\d{1,2},\d{1,3} m|highest point:\n*\t*\n*\t*.*\d{1,3} m/)
      high_e = elevations.text.match(/highest point:\n*\t*\n*\t*.*\d{1,2},\d{1,3} m|highest point:\n*\t*\n*\t*.*\d{1,3} m/)[0].match(/-*\d{1,2},\d{1,3}|-*\d{1,3}/)[0]
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
      else
        'Incorrect Size'
      end
    end

    # Search For Political Parties - NON-GREEDY -->  REVIEW THIS PART AGAIN
    count = 0
    political_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Govt').inner_html.match(/title="Notes and Definitions: Political parties and leaders".*?(<tr class=\"mde_light\>"|note:)/m)
    if political_html
      parties_html = political_html[0].scan(/category_data.*?div>/)
      count += parties_html.size
#       parties_html.each do |str|
#         if str =~ /\d{1,3} political parties/
#           count =+ str.match(/\d{1,3}/)[0].to_i - 1
#         end
#       end
      if political_html[0] =~ /note:/ && count > 0
        count -= 1
      end
    end
    country[ctry_name].p_party_num = count

    # Get the population of the country
    population_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_People').inner_html.match(/title="Notes and Definitions: Population".*?<span/m)
    if population_html && population_html[0] =~ (/\d{0,3},*\d{0,3},*\d{0,3},*\d{3}/)
      population = population_html[0].match(/\d{0,3},*\d{0,3},*\d{0,3},*\d{3}/)[0].split(',')
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
    e_consumption_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Energy').inner_html.match(/title="Notes and Definitions: Electricity - consumption".*?(<span)/m)
    if e_consumption_html
      e_consumption = e_consumption_html[0].match(/\d{1,3}.\d{0,3} (billion|trillion|kWh|million)/)[0].split(' ')
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
    religion_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_People').inner_html.match(/title="Notes and Definitions: Religions".*?(title="Notes and Definitions: Population"|,)/m)
    if religion_html
      if religion_html[0] =~ (/\d{1,2}\.{0,1}\d{0,2}%/)
        country[ctry_name].r_percentage = religion_html[0].match(/\d{1,2}\.{0,1}\d{0,2}%/)[0][0..-2].to_f
      else
        # religion = religion_html[0].match(/Roman Catholic|Daoist|Muslim|Lutheran|Protestant|Buddhist|Anglican|animist|Christian/)[0]
        country[ctry_name].r_percentage = 100
      end
    else
      country[ctry_name].r_percentage = 0
    end

    # Getting landlocked countries and neighbors
    country[ctry_name].landlocked = 0
    maritime_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo').inner_html.match(/title="Notes and Definitions: Coastline".*?(title="Notes and Definitions: Maritime claims"|landlocked)/m)
    if maritime_html
      if maritime_html[0] =~ (/landlocked/)
        country[ctry_name].landlocked = 1
      end
    end

    # Number of neighbors
    neighbors_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo').inner_html.match(/title="Notes and Definitions: Land boundaries".*?title="Notes and Definitions: Coastline"/m)
    if neighbors_html
      neighbors_html = neighbors_html[0].match(/border countries:.*div>/m)
      if neighbors_html
        country[ctry_name].neighbors = neighbors_html[0].scan(/\d{0,3},*\d{1,3} km/).size
      else
        country[ctry_name].neighbors = 0
      end
    else
      country[ctry_name].neighbors = 0
    end

    # GPD per capita
          country[ctry_name].gdp_pc = 0
    gdppc_html = country[ctry_name].HTML.css('div#CollapsiblePanel1_Econ').inner_html.match(/title="Notes and Definitions: GDP - per capita \(PPP\)".*?<span/m)
    if gdppc_html
      if gdppc_html[0].scan(/\$\d{0,3},*\d{1,3}/).size > 0
        get_number = gdppc_html[0].scan(/\$\d{0,3},*\d{1,3}/)[0][1..-1].split(',') 
        if get_number.size > 1
          country[ctry_name].gdp_pc = (get_number[0]<<get_number[1]).to_i
        else
          country[ctry_name].gdp_pc = get_number[0].to_i
        end
      end
    end

  end   # Of the initial names.each!!!
  puts 'Finisehd getting information!'
  country
end

# ############################################### Question Answers ######################################################
# #######################################################################################################################
# Countries with disasters in Continents.
def question_1(names, country, options = {})
  @continent = options[:continent] || ['South America']
  @disaster  = options[:disaster]  || ['earthquake']

  @continent.each do |continent|
    puts ''
    @disaster.each do |disaster|
      names.each do |ctry_name|
        # Check for Earthquakes.
        # To make it fancier we have to create and array of disasters and the check for all of them in the question answer.
        if country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').text =~ /#{disaster}/
          confirm = 1
        else
          cofirm = 0
        end
        # Get countries in @continent that have earthquakes.
        if country[ctry_name].continent == continent && confirm == 1
          puts "#{ctry_name} is in #{country[ctry_name].continent} and it's prone to #{disaster}s"
        end
      end
    end
  end
  nil
end

# Elevation Comparisson in Continent
def question_2(names, country, options = {})
  @continent = options[:continent] || 'Europe'
  @limit  = options[:limit]  || 0     # 0 For lowest point. 1 for highest point.
  ctry_index = 0

  # Look for the highest elevation point in @continent
  if @limit == 1
    max = 0
    names.each_with_index do |ctry_name, index|
      if country[ctry_name].continent == @continent && country[ctry_name].high_elev && country[ctry_name].high_elev > max
        max = country[ctry_name].high_elev
        ctry_index = index
      end
    end
    puts "The country in #@continent that has the highest elevation is #{country[names[ctry_index]]}. It's highest elevation is of #{country[names[ctry_index]].high_elev} m"

  # Look for the lowest elevation point in @continent.
  else
    min = 20_000
    names.each_with_index do |ctry_name, index|
      # Get countries in @continent that have the lowest elevation point.
      if country[ctry_name].continent == @continent && country[ctry_name].low_elev && country[ctry_name].low_elev < min
        min = country[ctry_name].low_elev
        ctry_index = index
      end
    end
    puts "The country in #{@continent} that has the lowest elevation is #{country[names[ctry_index]]}. It's lowest elevation is of #{country[names[ctry_index]].low_elev} m"
  end
  nil
end

# Hemisfere Queadrant Belonging
def question_3(names, country, options = {})
  @longitude  = options[:longitude]  || 'S'
  @latitude   = options[:latitude]   || 'E'

  puts "The countries that are in the #{@longitude}#{@latitude} hemisphere are:"
  names.each do |ctry_name|
    if country[ctry_name].longitude =~ /#{@longitude}/ && country[ctry_name].latitude =~ /#{@latitude}/
      puts country[ctry_name].name
    end
  end
  nil
end

# Political Parties
def question_4(names, country, options = {})
  @continent = options[:continent] || 'Asia'
  @min_num_pp = options[:min] || 10

  names.each do |ctry_name|
    # Get countries in @continent that have more than @min_pp_num of political parties.
    if country[ctry_name].continent == @continent && country[ctry_name].p_party_num > @min_num_pp
      puts "#{country[ctry_name]} is in #{country[ctry_name].continent} and has #{country[ctry_name].p_party_num} political parties."
    end
  end
  nil
end

# Electric Consumption per Capita
def question_5(country, options = {})
  # @continent = options[:continent] || 'Asia'
  @ctry_num = options[:num] || 5
  num_array = *(0..@ctry_num - 1)

  ctry_list = country.sort_by { |ctry, hash| hash.c_per_capita }.last(@ctry_num).reverse
  num_array.each do |x|
    puts "#{ctry_list[x][1].name} has the #{x + 1} electric consumption per capita with #{'%.02f' % ctry_list[x][1].c_per_capita} kWh/inhabitant"
  end
  nil
end
# #### COULD USE THIS country.sort_by{|ctry| ctry[1].c_per_capita}.last(@number)

# Political Parties
def question_6(names, country, options = {})
  @l_limit = options[:low]  || 50
  @h_limit = options[:high] || 80

  names.each do |ctry_name|
    if country[ctry_name].r_percentage > @h_limit
      puts "#{country[ctry_name]} has a predominant religion, with #{country[ctry_name].r_percentage} % of the poputation."
    end
  end
  puts ''
  names.each do |ctry_name|
    if country[ctry_name].r_percentage < @l_limit
      puts "#{country[ctry_name]} has a predominant religion, with #{country[ctry_name].r_percentage} % of the poputation."
    end
  end
  nil
end

# Landlocked countries with X or less neighbors
def question_7(names, country, options = {})
  @neighbors = options[:neighbors]  || 1

  names.each do |ctry_name|
    if country[ctry_name].landlocked == 1 && country[ctry_name].neighbors <= @neighbors
      puts "#{country[ctry_name]} is a landlocked country, with only #{country[ctry_name].neighbors} neighbors."
    end
  end
  nil
end

# ############################################ EXECUTING CODE ######################################################

# names, country = initial_Load
# country = vlook_continent(names, country)
