import java.util.*;

public class Roster1 implements Roster{

	private SortedSet<Player> players;
	
	Roster1(){
		this.players = new TreeSet<Player>();
	}
	
	Roster1(SortedSet<Player> players){
		this.players = players;
	}
	
	public Roster with(Player p) {
		SortedSet<Player> newRosterSet = new TreeSet<Player>(this.players);
		newRosterSet.add(p);
		return new Roster1(newRosterSet);
	}

	public Roster without(Player p) {
		SortedSet<Player> newRosterSet = new TreeSet<Player>(this.players);
		newRosterSet.remove(p);
		return new Roster1(newRosterSet);
	}

	public boolean has(Player p) {
		return this.players.contains(p);
	}

	public int size() {
		return this.players.size();
	}

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

	public Roster readyRoster() {
		SortedSet<Player> readySet = new TreeSet<Player>();
		Iterator<Player> iter = this.iterator();
		while(iter.hasNext()){
			Player p = iter.next();
			if(p.available()){
				readySet.add(p);
			}
		}
		return new Roster1(readySet);
	}

	public Iterator<Player> iterator() {
		return this.players.iterator();
	}
}
