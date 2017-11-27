// To compile:
//
//     javac *.java
//
// To run:
//
//     java Tests

// This class defines a main method for testing the Rosters & Players classes.

import java.util.*;

class Tests {

    public static void main (String[] args) {
    	Player a = Players.make("A");
		Player b = Players.make("B");
		Player c = Players.make("C");
		Player d = Players.make("D");
		Player aCopy = Players.make("A");
		d.changeContractStatus(false);
		
		Roster empty = Rosters.empty();
		Roster twoPlayers = Rosters.empty().with(a).with(b);
		Roster fourPlayer = Rosters.empty().with(a).with(b).with(c).with(d);
		
		checkTrue(a.equals(a));  // self equality test
		checkFalse(a.equals(b));  // equality of two different players
		checkTrue(a.available());  // availability of player
		checkFalse(d.available());  // unavailability of player
		checkTrue(a.hashCode() == aCopy.hashCode());  // hashcode equality
		checkTrue(empty.size() == 0);  // size method test
		checkTrue(twoPlayers.size() == twoPlayers.with(a).size());  // repetetive player test
		checkFalse(empty.equals(twoPlayers));  // equals method test
		checkTrue(twoPlayers.has(a));  // has method test
		checkFalse(empty.has(a));  // has method test
		checkFalse(twoPlayers.hashCode() == fourPlayer.hashCode());  // hashcode equality
		checkTrue(twoPlayers.equals(Rosters.empty().with(b).with(a)));  // equals method test
		checkTrue(Rosters.empty().equals(Rosters.empty().without(aCopy)));  // without method test
		checkTrue(twoPlayers.equals(fourPlayer.without(d).without(c)));  // without method test
		checkTrue(fourPlayer.readyCount() == 3);  // readyCount test
		checkTrue(twoPlayers.with(c).equals(fourPlayer.readyRoster()));  // readyRoster test
		aCopy.changeInjuryStatus(true);
		checkFalse(Rosters.empty().with(a).equals(Rosters.empty().with(aCopy)));
		checkFalse(a.equals(aCopy));
		summarize();
    }

    ////////////////////////////////////////////////////////////////

    private static int testsPassed = 0;
    private static int testsFailed = 0;

    private static final String FAILED
        = "    TEST FAILED: ";

    static void checkTrue (boolean result) {
        checkTrue (result, "anonymous");
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
        checkFalse (result, "anonymous");
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