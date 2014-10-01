#basic class to store movie information
class Country 
  attr_accessor :continent, :population, :name, :link, :low_elev, :high_elev, :latitude, :longitude, :HTML, :disaster

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
  end

  def to_s
    "#{self.name}"
  end

end