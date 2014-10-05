class Person
  attr_accessor :name, :friends

  # Initialize a Person
  def initialize(name, friends)
    @name = name
    @friends = friends
  end

  # Return person name
  def to_s
    @name
  end

  # Return list of friends
  def get_friends
    @friends
  end

end