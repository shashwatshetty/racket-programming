// This class contains a static factory method for creating objects of classes
// that implement the RosterWithStream Interface.

public class RosterWithStreams {
	// static factory method for creating a Roster.
	
	// RETURNS: an RosterWithStream with no Players in it.
	
	public static RosterWithStream empty(){
		return new RosterWithStream1();
	}
}
