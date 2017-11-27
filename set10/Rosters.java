// This class contains a static factory method for creating objects of classes
// that implement the Roster Interface.
public class Rosters {
	// static factory method for creating a Roster.
	
	// RETURNS: an Roster with no Players in it.
	
	public static Roster empty(){
		return new Roster1();
	}
}
