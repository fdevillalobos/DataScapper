import java.util.Scanner;

/*
 * The main program to test the FriendTracker
 */
public class FriendProgram {

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);

		//prompt the user for file name
		System.out.println("Please enter the name of a file");
		String fileName = in.next();
		
		FriendTracker ft = new FriendTracker();
		ft.loadFile(fileName);
		
		System.out.println("The person with the most friends is " + ft.mostFriends());
		
		System.out.println("Lucy and Charlie have " + ft.friendsInCommon("Lucy", "Charlie") + " friends in common");
		System.out.println("Sally and Charlie have " + ft.friendsInCommon("Sally", "Charlie") + " friends in common");
		
		System.out.println("The suggested friend for Charlie is " + ft.suggestFriend("Charlie"));
		
		
	}
}
