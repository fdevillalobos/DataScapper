require 'nokogiri'
require 'open-uri'
require 'sinatra'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
page = 'https://www.cis.upenn.edu/~swapneel/test.html'
doc = Nokogiri::HTML(open(page))


get '/swap' do
	doc.css("table tr td").each do |row|
	  print row.content		# We have print, puts, and p. We usually use puts. p = puts.object.inspect. Look up differences
	end
	"Hey Man!"
end	