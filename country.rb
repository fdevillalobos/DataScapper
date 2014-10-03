#basic class to store movie information
class Country 
  attr_accessor :name, :continent, :population, :link, :low_elev, :high_elev, :latitude, :longitude, :HTML, :disaster, :p_party_num, :elec_consumption, :neighbors, :r_percentage, :landlocked

  def initialize(name, options)
    self.name = name
    self.continent = options[:continent]
    self.population = options[:population]
    self.link = "https://www.cia.gov/library/publications/the-world-factbook/#{options[:link][0]}"
    self.low_elev = options[:low_elev]
    self.high_elev = options[:high_elev]
    self.latitude = options[:latitude]
    self.longitude = options[:longitude]
    self.HTML = options[:HTML]
    self.disaster = options[:disaster]
    self.p_party_num = options[:p_party_num]
    self.elec_consumption = options[:elec_consumption]
    self.neighbors = options[:neighbors]
    self.r_percentage = options[:r_percentage]
    self.landlocked = options[:landlocked]
  end
  
  def c_per_capita
    if population > 0
      return elec_consumption.to_f/population
    else
      0
    end
  end
  
  def to_s
    "#{self.name}"
  end

end



# Instance variable with only one @
# Class variable with two @@
# Local variables

