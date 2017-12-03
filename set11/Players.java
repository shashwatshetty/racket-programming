
// This class contains a static factory method for creating objects of classes
// that implement the Player Interface.
public class Players {
	
	// static factory method for creating a Player.
	
	// GIVEN: a name.
	// RETURNS: a Player with the given name.
	
	public static Player make(String name){
		return new Player1(name);
	}
}
