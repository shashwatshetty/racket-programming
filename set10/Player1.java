// Constructor template for Player1:

//     new Player1 (String name)
//
// Interpretation:
//		name:  is the name of the player.

public class Player1 implements Player, Comparable{

	private String playerName;     // name of the player.
	private boolean underContract; // true iff player is under contract.
	private boolean isInjured;	   // true iff player is injured.
	private boolean isSuspended;   // true iff player is suspended.
	
	Player1(String name){
		this.playerName = name;
		this.underContract = true;
		this.isInjured = false;
		this.isSuspended = false;
	}
	
	// Returns the name of this player.
    
	public String name() {
		return this.playerName;
	}

	// Returns true iff this player is
    //     under contract, and
    //     not injured, and
    //     not suspended
	
	public boolean available() {
		return !(this.isInjured) && this.underContract && !(this.isSuspended);
	}

	// Returns true iff this player is under contract (employed).
	
	public boolean underContract() {
		return this.underContract;
	}

	// Returns true iff this player is injured.
	
	public boolean isInjured() {
		return this.isInjured;
	}

	// Returns true iff this player is suspended.

	public boolean isSuspended() {
		return this.isSuspended;
	}

	// Changes the underContract() status of this player
    // to the specified boolean.
	
	public void changeContractStatus(boolean newStatus) {
		this.underContract = newStatus;
	}

	// Changes the isInjured() status of this player
    // to the specified boolean.
	
	public void changeInjuryStatus(boolean newStatus) {
		this.isInjured = newStatus;
	}

	// Changes the isSuspended() status of this player
    // to the specified boolean.
	
	public void changeSuspendedStatus(boolean newStatus) {
		this.isSuspended = newStatus;
	}

	// Returns the hashcode of this player object.
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + 
					((playerName == null) ? 0 : playerName.hashCode());
		return result;
	}

	// RETURNS: true iff this player object and the given obj
	// 			  are the same.
	
	// EXAMPLES:
	// Player p1 = Players.make("A")
	// Player p2 = Players.make("B")
	// Player p = p1
	// p1.equals(p2)  => false
	// p1.equals(p)   => true
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Player) {
            Player p = (Player) obj;
            return this == p;
        }
        else return false;
	}

	// GIVEN: an object o
	// WHERE: the object is another Player.
	// RETRUNS: -1 iff this player has a name lexicographically less than
	// 			  the given player's name
	//			 0 iff this player has a name lexicographically same as
	// 			  the given player's name.
	//			 1 iff this player has a name lexicographically more than
	// 			  the given player's name.
		
	// EXAMPLES:
	// Player p1 = Players.make("A")
	// Player p2 = Players.make("B")
	// Player p3 = PLayers.make("C")
	// p2.comapreTo(p1)  => -1
	// p2.compareTo(p2)  =>  0
	// p2.compareTo(p3)  =>  1
	
	@Override
	public int compareTo(Object o) {
		Player p = (Player) o;
		return this.name().compareTo(p.name());
	}
}
