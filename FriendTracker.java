import java.io.File;
import java.util.HashMap;
import java.util.Scanner;
import java.util.Set;

/**
 * This class will track friends
 * @author swapneel
 */
public class FriendTracker {

	/*ATTRIBUTES*/
	//we use the normal array here - could use ArrayList instead
	private Person[] people = new Person[100];

	/**
	 * This method searches for a person by name
	 * @param name The name to search for
	 * @return The Person object corresponding to that name, null otherwise
	 */
	public Person findPerson(String name) {
		for (Person p : people) {         /*This mean for Person p IN PEOPLE */
			if (p != null && p.getName().equals(name)) return p;
		}
		return null;
	}

	/**
	 * This method reads a file, creates a Person object and adds it to the people array
	 * @param fileName The name of the file to read
	 */
	public void loadFile(String fileName) {
		try {
			Scanner in = new Scanner(new File(fileName));
			int count = 0;
			while(in.hasNext()) {
				//read the line
				String line = in.nextLine();
				//split on the : to get the name and list of friends
				String[] splitLine = line.split(":\\s");
				String personName = splitLine[0];
				//get rid the trailing period
				String friendList = splitLine[1].substring(0, splitLine[1].length()-1);
				//split the friend list on the , to get individual friends
				String[] friends = friendList.split(",\\s");
				//create the new person object and add to the people array
				Person newPerson = new Person(personName, friends);
				people[count] = newPerson;
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * This method will find who has the most friends
	 * @return The name of the person who has the most friends
	 */
	public String mostFriends() {
		String currentMax = null;
		int maxCount = 0;
		for (Person p : people) {
			if (p != null) {
				int count = p.getFriends().length;
				if (count > maxCount) {
					maxCount = count;
					currentMax = p.getName();
				}
			}
		}
		return currentMax;
	}
	
	/**
	 * This method will find how many friends there are in common between 2 people
	 * @param name1 person1 to search for
	 * @param name2 person2 to search for
	 * @return integer representing how many friends they have in common
	 */
	public int friendsInCommon(String name1, String name2) {
		int count = 0;
		Person p1 = findPerson(name1);
		Person p2 = findPerson(name2);
		if (p1 == null || p2 == null) return 0;
		String[] friends1 = p1.getFriends();
		String[] friends2 = p2.getFriends();
		for (String friend : friends1) {
			if (exists(friends2, friend)) {
				count++;
			}
		}
		return count;
	}
	
	/**
	 * This is a helper method that will check if a name exists in an array
	 * @param array The array to search through
	 * @param name The name to look for
	 * @return true if the string exists in the array
	 */
	private boolean exists(String[] array, String name) {
		for(int i = 0; i<array.length; i++) {
			if (name.equals(array[i])) return true;
		}
		return false;
	}
	
	/**
	 * This method will suggest a new friend for a person
	 * It will first find all the friends of the "name" and then look at all the friends of the friends to see which one is the most common
	 * @param name The name of the person to suggest a friend for
	 * @return The name of the suggested friend
	 */
	public String suggestFriend(String name) {
		String friendSuggestion = null;
		HashMap<String, Integer> list = new HashMap<String, Integer>();
		Person currentPerson = findPerson(name);
		if (currentPerson == null) return null;
		//get the list of friends
		String[] friends = currentPerson.getFriends();
		for(String friend : friends) {
			Person p = findPerson(friend);
			if (p != null) {
				//get the friends of friends
				String[] friendsOfFriends = p.getFriends();
				for (String possibleFriend : friendsOfFriends) {
					//can be a possible suggested friend as long as two checks hold
					//1.the possible friend is not the same as the original person, i.e., "name"
					//2.the possible friend is not already a friend of "name"
					if (!(possibleFriend.equals(name)) && !(exists(friends, possibleFriend))) {
						//the hashmap stores key, value pair corresponding to
						//key = name of suggested friend
						//value = number of friends who know this person
						//higher the value, better the suggestion
						if (list.containsKey(possibleFriend)) {
							//increment the value in the hashmap
							Integer value = list.get(possibleFriend);
							value++;
							list.remove(possibleFriend);
							list.put(possibleFriend, value);
						} else {
							//add a new key, value
							list.put(possibleFriend, new Integer(1));
						}
					}
				}
			}
		}
		//find the max value in the list and return the corresponding key
		//this key will be the suggested friend
		friendSuggestion = getMax(list);
		return friendSuggestion;
	}
	
	/**
	 * This method takes a hashmap and returns the key having the greatest value
	 * @param list the hashmap to search through
	 * @return the string that has the greatest value
	 */
	private String getMax(HashMap<String, Integer> list) {
		Set<String> k = list.keySet();
		
		Integer maxCount = new Integer(-1);
		String maxName = null;
		
		for(Object o : k) {
			Integer count = list.get(o);
			if (count > maxCount) {
				maxCount = count;
				maxName = o.toString();
			}
		}
		return maxName;
	}

}
