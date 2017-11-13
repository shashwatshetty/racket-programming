// To compile:
//
//     javac *.java
//
// To run:
//
//     java Tests

// This class defines a main method for testing the Competitor1 class,
// which implements the Competitor interface.

import java.util.*;

class Tests {

    public static void main (String[] args) {
		// All Tests Competitors
        Competitor1 A = new Competitor1("A");
		Competitor1 B = new Competitor1("B");
		Competitor1 C = new Competitor1("C");
		Competitor1 D = new Competitor1("D");
		Competitor1 E = new Competitor1("E");
		Competitor1 Z = new Competitor1("Z");
		Competitor1 X = new Competitor1("X");
		Competitor1 W = new Competitor1("W");
		
		// Test 1 Outcomes
		Defeat1 ZdefA = new Defeat1(Z, A);
		Defeat1 AdefB = new Defeat1(A, B);
		Defeat1 BdefZ = new Defeat1(B, Z);
		Defeat1 EdefZ = new Defeat1(E, Z);
		Defeat1 EdefD = new Defeat1(E, D);
		Tie1 ZtieC = new Tie1(Z, C);
		Tie1 CtieD = new Tie1(C, D);
		
		// Test 1 OutcomeList
		List<Outcome> test1Outcomes = new ArrayList<Outcome>();
		test1Outcomes.add(ZdefA);
		test1Outcomes.add(AdefB);
		test1Outcomes.add(BdefZ);
		test1Outcomes.add(ZtieC);
		test1Outcomes.add(CtieD);
		test1Outcomes.add(EdefZ);
		test1Outcomes.add(EdefD);
		
		// Test 2 Outcomes
		Defeat1 ZdefW = new Defeat1(Z, W);
		Tie1 ZtieX = new Tie1(Z, X);
		
		// Test 2 OutcomeList
		List<Outcome> test2Outcomes = new ArrayList<Outcome>();
		test2Outcomes.add(ZdefW);
		test2Outcomes.add(ZtieX);
		
		
		Competitor1 testObj = new Competitor1("testObj");
		
		String test1Expected = "[E, C, A, B, D, Z]";
		String test2Expected = "[X, Z, W]";
		
		
		checkTrue(test1Expected.equals(testObj.powerRanking(test1Outcomes).toString()));
		checkTrue(test2Expected.equals(testObj.powerRanking(test2Outcomes).toString()));
		checkTrue(A.hasDefeated(B, test1Outcomes));
		checkTrue(Z.hasDefeated(C, test1Outcomes));
		checkFalse(D.hasDefeated(E, test1Outcomes));
		

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