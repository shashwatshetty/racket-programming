// This class defines a main method for testing the RosterWithStreams & Players classes.

import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Stream;
class TestRosterWithStream {

    public static void main (String[] args) {
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
    	checkTrue(RosterWithStreams.empty().stream().count() == RosterWithStreams.empty().size());
    	checkTrue(r1.stream().count() == r1.size());
    	checkTrue(r1.stream().count() == r1.with(p2).with(p1).with(p2).size());
    	checkFalse(r1.stream().count() == r1.with(p5).size());
    	
    	// testing distinct():
    	checkTrue(RosterWithStreams.empty().stream().distinct().count() == RosterWithStreams.empty().size());
    	checkTrue(r1.stream().distinct().count() == r1.size());
    	checkTrue(r1.with(p1).stream().distinct().count() == r1.with(p2).with(p1).with(p2).size());
    	checkFalse(r1.stream().distinct().count() == r1.with(p5).size());
    	
    	// testing filter():
    	Stream<Player> zeroInjured = r1.stream().filter(pred3);
    	checkTrue(zeroInjured.count() == 0);
    	Stream<Player> oneInjured = r4.stream().filter(pred3);
    	checkTrue(oneInjured.count() == (r4.size() - 1));
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