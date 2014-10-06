require './person'

class FRIENDTRACKER
  #class_variable_set(:@@people, [])
  @people = []

  def find_person(name)
    #This method searches for a person by name
    #@param name The name to search for
    #@return The Person object corresponding to that name, null otherwise
    per = @@people.select { |p| p != nil && p.to_s == name }
    (per != nil) ?
        per[0] :
        nil
  end

  def load_file(filename)
    # This method reads a file, creates a Person object and adds it to the people array
    # @param fileName The name of the file to read
    string = File.open(filename, 'rb') { |f| f.read }
    person_raw = string.split(/.\n/)
    @@people = person_raw.map { |per| Person.new(per.split(':')[0], per.split(':')[1].split(',').map(&:strip)) }
  end

  def most_friends
    # This method will find who has the most friends
    # @return The name of the person who has the most friends
    @@people.sort_by { |per| per.get_friends.size }.last(1)[0].to_s
  end

  def friends_in_common(name_1, name_2)
    # This method will find how many friends there are in common between 2 people
    # @param name1 person1 to search for
    # @param name2 person2 to search for
    # @return integer representing how many friends they have in common
    (find_person(name_1).get_friends & find_person(name_2).get_friends).length
  end

  def exists(array, name)
    # This is a helper method that will check if a name exists in an array
    # @param array The array to search through
    # @param name The name to look for
    # @return true if the string exists in the array
    (array.select { |per| per == name}.size > 0) ?
      true :
      false
  end

  def suggest_friend(name)
    # This method will suggest a new friend for a person
    # It will first find all the friends of the "name" and then look at all the friends of the friends to see which one is the most common
    # @param name The name of the person to suggest a friend for
    # @return The name of the suggested friend
    friend_friends, all_ffriends, recommendation = [], [], ''
    max = 0

    find_person(name).get_friends.map { |friend|
      friend_friends = friend_friends | find_person(friend).get_friends
      all_ffriends = all_ffriends + find_person(friend).get_friends
    }
    friend_friends.each do |fri|
      repet = all_ffriends.select { |name| name == fri }
      if repet.size > max
        max = repet.size
        recommendation = repet[0]
      end
    end
    recommendation
  end

  def get_max(list)
    #	This method takes a hashmap and returns the key having the greatest value
    #	@param list the hashmap to search through
    #	@return the string that has the greatest value
    hola = list.sort_by { |key, hash| hash }.last(1).reverse[0]
    hola[0]
  end

end

class FRIENDPROGRAM

  def main(args)
    file_nam = [(print 'Please enter the name of a file: '), gets.rstrip][1]
    load_file(file_nam)
    puts "The person with the most friends is #{most_friends}"
    puts "Lucy and Charlie have #{friends_in_common("Lucy", "Charlie")} friends in common"
    puts "Sally and Charlie have #{friends_in_common("Sally", "Charlie")} friends in common"
    puts "The suggested friend for Charlie is #{suggest_friend("Charlie")}"
  end

end
