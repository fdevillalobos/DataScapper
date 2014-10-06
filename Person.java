/**
 * This class represents a person and contains the person's friends
 * @author swapneel
 */
public class Person {
	
	/*ATTRIBUTES*/
	private String name;
	private String[] friends;
	
	/**
	 * The constructor
	 * @param name The name of the person
	 * @param friends The array of friends
	 */
	public Person(String name, String[] friends) {
		this.name = name;
		this.friends = friends;
	}

	/**
	 * The accessor method for the name
	 * @return The Name of the person
	 */
	public String getName() {
		return name;
	}

	/**
	 * The accessor for the person's friends
	 * @return The array of friend names
	 */
	public String[] getFriends() {
		return friends;
	}
}
