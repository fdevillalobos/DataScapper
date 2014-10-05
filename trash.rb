# TRASH FROM MAIN_LITE


#@continent.each do |continent|
#  puts ''
#  @disaster.each do |disaster|
#    names.each do |ctry_name|
#      # Check for Earthquakes.
#      # To make it fancier we have to create and array of disasters and the check for all of them in the question answer.
#      (country[ctry_name].HTML.css('div#CollapsiblePanel1_Geo td#data div.category_data').text =~ /#{disaster}/) ?
#          confirm = 1 :
#          confirm = 0
#      # Get countries in @continent that have earthquakes.
#      if country[ctry_name].continent == continent && confirm == 1
#        puts "#{ctry_name} is in #{country[ctry_name].continent} and it's prone to #{disaster}s"
#      end
#    end
#  end
#end


#question_2
#min = 20_000
#names.each_with_index do |ctry_name, index|
#  # Get countries in @continent that have the lowest elevation point.
#  if country[ctry_name].continent == @continent && country[ctry_name].low_elev && country[ctry_name].low_elev < min
#    min = country[ctry_name].low_elev
#    ctry_index = index
#  end
#end
#puts "The country in #{@continent} that has the lowest elevation is #{country[names[ctry_index]]}. It's lowest elevation is of #{country[names[ctry_index]].low_elev} m"
#end

#names.each_with_index do |ctry_name, index|
#  if country[ctry_name].continent == @continent && country[ctry_name].high_elev && country[ctry_name].high_elev > max
#    max = country[ctry_name].high_elev
#    ctry_index = index
#  end
#end
#puts "The country in #{@continent} that has the highest elevation is #{country[names[ctry_index]]}. It's highest elevation is of #{country[names[ctry_index]].high_elev} m"


# question_3
#names.each do |ctry_name|
#  if country[ctry_name].longitude =~ /#{@longitude}/ && country[ctry_name].latitude =~ /#{@latitude}/
#    puts country[ctry_name].name
#  end
#end

#question_4
#names.each do |ctry_name|
#  # Get countries in @continent that have more than @min_pp_num of political parties.
#  if country[ctry_name].continent == @continent && country[ctry_name].p_party_num > @min_num_pp
#    puts "#{country[ctry_name]} is in #{country[ctry_name].continent} and has #{country[ctry_name].p_party_num} political parties."
#  end
#end

#question_6
#names.each do |ctry_name|
#  if country[ctry_name].r_percentage > @h_limit
#    puts "#{country[ctry_name]} has a predominant religion, with #{country[ctry_name].r_percentage} % of the poputation."
#  end
#end
#puts ''
#names.each do |ctry_name|
#  if country[ctry_name].r_percentage < @l_limit
#    puts "#{country[ctry_name]} has a predominant religion, with #{country[ctry_name].r_percentage} % of the poputation."
#  end
#end

#question_7
#names.each do |ctry_name|
#  if country[ctry_name].landlocked == 1 && country[ctry_name].neighbors <= @neighbors
#    puts "#{country[ctry_name]} is a landlocked country, with only #{country[ctry_name].neighbors} neighbors."
#  end
#end

#question_8
#continent_gdp[index], continent_popu[index] = 0, 0
#names.each do |ctry_name|
#  if country[ctry_name].continent == continent
#    continent_gdp[index] += country[ctry_name].gdp_pc * country[ctry_name].population
#    continent_popu[index] += country[ctry_name].population if country[ctry_name].continent == continent
#  end
#end
#c_gdp_per_c[index] = continent_gdp[index].to_f / continent_popu[index]
#puts "#{continent} has a accumulated GDP per capita of: $#{c_gdp_per_c[index]}"



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