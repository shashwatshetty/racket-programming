// This class defines a main method for testing the RosterWithStreams & Players classes.

import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Stream;
class TestRosterWithStream {

    public static void main (String[] args) {
    	Player a = Players.make("A");
		Player b = Players.make("B");
		Player c = Players.make("C");
		Player d = Players.make("D");
		Player aCopy = Players.make("A");
		d.changeContractStatus(false);
    	
		RosterWithStream empty = RosterWithStreams.empty();
		RosterWithStream twoPlayers = RosterWithStreams.empty().with(a).with(b);
		RosterWithStream fourPlayer = RosterWithStreams.empty().with(a).with(b).with(c).with(d);
		
		checkTrue(a.equals(a));  // self equality test
		checkFalse(a.equals(b));  // equality of two different players
		checkTrue(a.available());  // availability of player
		checkFalse(d.available());  // unavailability of player
		checkTrue(empty.size() == 0);  // size method test
		checkTrue(twoPlayers.size() == twoPlayers.with(a).size());  // repetetive player test
		checkFalse(empty.equals(twoPlayers));  // equals method test
		checkTrue(twoPlayers.has(a));  // has method test
		checkFalse(empty.has(a));  // has method test
		checkFalse(twoPlayers.hashCode() == fourPlayer.hashCode());  // hashcode equality
		checkTrue(twoPlayers.equals(RosterWithStreams.empty().with(b).with(a)));  // equals method test
		checkTrue(RosterWithStreams.empty().equals(RosterWithStreams.empty().without(aCopy)));  // without method test
		checkTrue(twoPlayers.equals(fourPlayer.without(d).without(c)));  // without method test
		checkTrue(fourPlayer.readyCount() == 3);  // readyCount test
		checkTrue(twoPlayers.with(c).equals(fourPlayer.readyRoster()));  // readyRoster test
		aCopy.changeInjuryStatus(true);
		checkFalse(RosterWithStreams.empty().with(a).equals(RosterWithStreams.empty().with(aCopy)));
		checkFalse(a.equals(aCopy));
    	
    	/**** TESTING STREAM METHODS *****/
		Player p1 = Players.make("A");
		Player p2 = Players.make("B");
		Player p3 = Players.make("C");
		Player p4 = Players.make("D");
		Player p5 = Players.make("E");
		Player p6 = Players.make("F");
		p5.changeContractStatus(false);
		p6.changeInjuryStatus(true);
		RosterWithStream r1 = RosterWithStreams.empty().with(p1).with(p2);
		RosterWithStream r2 = RosterWithStreams.empty().with(p3).with(p4);
		RosterWithStream r3 = RosterWithStreams.empty().with(p5).with(p2);
		RosterWithStream r4 = RosterWithStreams.empty().with(p3).with(p6);
		RosterWithStream r5 = RosterWithStreams.empty().with(p6).with(p5);
		Predicate<Player> pred1 = p -> p.available();
		Predicate<Player> pred2 = p -> p.underContract();
		Predicate<Player> pred3 = p -> p.isInjured();
    	
    	// testing allMatch() true condition:
    	checkTrue(r1.stream().allMatch(pred1));
    	checkTrue(r2.stream().allMatch(pred2));
    	
    	// testing allMatch() false conditions:
    	checkFalse(r4.stream().allMatch(pred1));
    	checkFalse(r3.stream().allMatch(pred2));
    	
    	// testing anyMatch() true condition:
    	checkTrue(r1.stream().anyMatch(pred1));
    	checkTrue(r3.stream().anyMatch(pred2));
    	
    	// testing anyMatch() false conditions:
    	checkFalse(r5.stream().anyMatch(pred1));
    	checkFalse(r2.stream().anyMatch(pred3));
    	
    	// testing count():
    	checkTrue(RosterWithStreams.empty()
    							   .stream()
    							   .count() == RosterWithStreams.empty()
    							   								.size());
    	checkTrue(r1.stream().count() == r1.size());
    	checkTrue(r1.stream().count() == r1.with(p2).with(p1).with(p2).size());
    	checkFalse(r1.stream().count() == r1.with(p5).size());
    	
    	// testing distinct():
    	checkTrue(RosterWithStreams.empty()
    							   .stream()
    							   .distinct()
    							   .count() == RosterWithStreams.empty()
    							   								.size());
    	checkTrue(r1.stream().distinct().count() == r1.size());
    	checkTrue(r1.with(p1)
    				.stream().distinct().count() == r1.with(p2)
    												  .with(p1)
    												  .with(p2).size());
    	checkFalse(r1.stream().distinct().count() == r1.with(p5).size());
    	
    	// testing filter():
    	Stream<Player> zeroInjured = r1.stream().filter(pred3);
    	checkTrue(zeroInjured.count() == 0);
    	Stream<Player> oneInjured = r4.stream().filter(pred3);
    	checkTrue(oneInjured.count() == (r4.size() - 1));
    	
    	// testing findAny():
    	Optional<Player> result = r1.stream().findAny();
    	checkTrue(result.isPresent());
    	result = RosterWithStreams.empty().stream().findAny();
    	checkFalse(result.isPresent());
    	
    	// testing findFirst():
    	result = r1.stream().findFirst();
    	checkTrue(result.get().name().equals(p1.name()));
    	result = RosterWithStreams.empty()
    							  .with(p5)
    							  .with(p6)
    							  .with(p3)
    							  .with(p4).stream().findFirst();
    	checkTrue(result.get().name().equals(p3.name()));
    	
    	// testing forEach():
    	r2.stream().forEach(p -> p.changeInjuryStatus(true));
    	checkTrue(r2.stream().allMatch(pred3));
    	
    	// testing map():
    	Stream<Object> nobodySuspended = r2.stream().map(p -> p.isSuspended());
    	checkTrue(nobodySuspended.allMatch(o -> o.equals(false)));
    	Stream<Object> unavailable = r2.stream().map(p -> p.available());
    	checkFalse(unavailable.allMatch(o -> o.equals(true)));
    	
    	// testing reduce():
    	Boolean andAvailable = r1.stream()
    							 .map(Player::available)
    							 .reduce(true, (x, y) -> x && y);
    	checkTrue(andAvailable);
    	Boolean andUnavailable = r2.stream()
    							   .map(Player::available)
    							   .reduce(true, (x, y) -> x && y);
    	checkFalse(andUnavailable);
    	
    	// testing skip():
    	long toSkip = 1;
    	Stream<Player> skipped1 = r1.stream().skip(toSkip);
    	checkTrue((r1.size() - 1) == skipped1.count());
    	checkFalse(RosterWithStreams.empty()
    					   			.with(p1)
    					   			.with(p1)
    					   			.stream()
    					   			.skip(toSkip)
    					   			.count() == 1);
    	
    	// testing toArray():
    	Object[] arr = r1.stream()
    					 .toArray();
    	checkTrue(arr.length == r1.size());
    	
		summarize();
    }

    ////////////////////////////////////////////////////////////////

    private static int testsPassed = 0;
    private static int testsFailed = 0;

    private static final String FAILED
        = "    TEST FAILED: ";

    static void checkTrue (boolean result) {
    	String message = "Test Number: "+(testsPassed+testsFailed);
        checkTrue (result, message);
    }

    static void checkTrue (boolean result, String name) {
        if (result)
            testsPassed = testsPassed + 1;
        else {
            testsFailed = testsFailed + 1;
            System.err.println (FAILED + name);
        }
    }

    static void checkFalse (boolean result) {
    	String message = "Test Number: "+(testsPassed+testsFailed);
        checkFalse (result, message);
    }

    static void checkFalse (boolean result, String name) {
        checkTrue (! result, name);
    }

    static void summarize () {
        System.err.println ("Passed " + testsPassed + " tests");
        if (testsFailed > 0) {
            System.err.println ("Failed " + testsFailed + " tests");
        }
    }
}