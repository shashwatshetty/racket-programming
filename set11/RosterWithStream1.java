import java.util.*;
import java.util.stream.Stream;

public class RosterWithStream1 implements RosterWithStream {

	private SortedSet<Player> players;  // set of players in this RosterWithStream.
	
	// default constructor.
	
	RosterWithStream1(){
		this.players = new TreeSet<Player>();
	}
	
	// parameterized constructor.
	
	RosterWithStream1(SortedSet<Player> players){
		// this players will store given set of players.
		this.players = players;
	}
	
	// GIVEN:    a player p.
	// RETURNS:  a RosterWithStream consisting of the given player together
	// 				with all players on this RosterWithStream.
	    
	// EXAMPLES:
	// r.with(p).with(p)  =>  r.with(p)
		
	@Override
	public RosterWithStream with(Player p) {
		SortedSet<Player> newRosterSet = new TreeSet<Player>(this.players);
		newRosterSet.add(p);
		return new RosterWithStream1(newRosterSet);
	}

	// GIVEN:    a player p.
	// RETURNS: a RosterWithStream consisting of all players on this RosterWithStream
	// 			except for the given player.
		
	// EXAMPLES:
	//     RosterWithStreams.empty().without(p)  =>  RosterWithStreams.empty()
	//     r.without(p).without(p)     =>  r.without(p)
		
	@Override
	public RosterWithStream without(Player p) {
		SortedSet<Player> newRosterSet = new TreeSet<Player>(this.players);
		newRosterSet.remove(p);
		return new RosterWithStream1(newRosterSet);
	}

	// GIVEN:    a player p.
	// RETURNS: true iff the given player is on this RosterWithStream.
	
    // Examples:
    //
    //     RosterWithStreams.empty().has(p)  =>  false
    //
    // If r is any RosterWithStream, then
    //
    //     r.with(p).has(p)     =>  true
    //     r.without(p).has(p)  =>  false
	
	@Override
	public boolean has(Player p) {
		Iterator<Player> iter = this.iterator();
		while(iter.hasNext()){
			Player inRoster = iter.next();
			if(inRoster.equals(p)){
				return true;
			}
		}
		return false;
	}

	// RETURNS:  the number of players on this RosterWithStream.
	
	// EXAMPLES:
	//
	//     RosterWithStreams.empty().size()  =>  0
	//
	// If r is a RosterWithStream with r.size() == n, and r.has(p) is false, then
	//     r.without(p).size()          =>  n
	//     r.with(p).size()             =>  n+1
	//     r.with(p).with(p).size()     =>  n+1
	//     r.with(p).without(p).size()  =>  n

	@Override
	public int size() {
		return this.players.size();
	}

	// RETURNS: the number of players on this RosterWithStream whose current
    // 				status indicates they are available.
	
	// EXAMPLES:
	// Player p1 = Players.make("A").changeInjuryStatus(true)
	// Player p2 = Players.make("B")
	// RosterWithStream r = RosterWithStreams.empty().with(p1).with(p2)
	// r.readyCount()  =>  1  

	@Override
	public int readyCount() {
		int readyCount = 0;
		Iterator<Player> iter = this.iterator();
		while(iter.hasNext()){
			Player p = iter.next();
			if(p.available()){
				readyCount += 1;
			}
		}
		return readyCount;
	}

	// RETURNS: a RosterWithStream consisting of all players on this RosterWithStream
    // 				whose current status indicates they are available.

	// EXAMPLES:
	// Player p1 = Players.make("A").changeInjuryStatus(true)
	// Player p2 = Players.make("B")
	// RosterWithStream r = RosterWithStreams.empty().with(p1).with(p2)
	// r.readyRoster()  =>  RosterWithStreams.empty().with(p2) 

	@Override
	public RosterWithStream readyRoster() {
		SortedSet<Player> readySet = new TreeSet<Player>();
		Iterator<Player> iter = this.iterator();
		while(iter.hasNext()){
			Player p = iter.next();
			if(p.available()){
				readySet.add(p);
			}
		}
		return new RosterWithStream1(readySet);
	}

	// RETURNS: an iterator that generates each player on this
    // 			  RosterWithStream exactly once, in alphabetical order by name.

	@Override
	public Iterator<Player> iterator() {
		SortedSet<Player> temp = new TreeSet<Player>(this.players);
		return temp.iterator();
	}

	@Override
	public Stream<Player> stream() {
		SortedSet<Player> temp = new TreeSet<Player>(this.players);
		return temp.stream();
		//return this.stream();
	}

	// RETURNS: the hash code for the Roster object.
	
	// EXAMPLES:
	// Rosters.empty().hasCode()  =>  *some int calculated with 
	//									using the reference of this.players*
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((players == null) ? 0 : players.hashCode());
		return result;
	}

	// GIVEN: an object obj
	// WHERE: the object is another Roster.
	// RETRUNS: true iff this roster contains all the players
	// 			  in the given roster.
	
	// EXAMPLES:
	// Let p1, p2, p3 are Players.
	// Roster r1 = Rosters.empty().with(p1).with(p2).with(p3)
	// Roster r2 = Rosters.empty().with(p2).with(p3).with(p1)
	// r1.equals(r2) 			  => true
	// r1.equals(Rosters.empty()) => false
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null){
			return false;
		}
		if(!(obj instanceof RosterWithStream)){
			return false;
		}
		RosterWithStream other = (RosterWithStream1)obj;
		if(this.size() != other.size()){
			return false;
		}else{
			Iterator<Player> thisIter = this.iterator();
			Iterator<Player> otherIter = other.iterator();
			while(thisIter.hasNext()){
				Player thisPlayer = thisIter.next();
				Player otherPlayer = otherIter.next();
				if(!other.has(thisPlayer) || !this.has(otherPlayer)){
					return false;
				}
			}
		}
		return true;
	}
}
