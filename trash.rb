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