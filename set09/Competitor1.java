// Constructor template for Competitor1:

//     new Competitor1 (String s)
//
// Interpretation: the competitor represents an individual or team

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.List;
import java.util.*;

class Competitor1 implements Competitor{

	
	String competitorName;  // the Name of the Competitor

	Competitor1(String s) {

		// Your code goes here.
		this.competitorName = s;

	}

	// returns the name of this competitor

	public String name() {

		return this.competitorName;

	}

	// GIVEN: 	another competitor and a list of outcomes
	// RETURNS: true iff one or more of the outcomes indicates this
	// 			  competitor has defeated or tied the given competitor

	public boolean hasDefeated(Competitor c2, List<Outcome> outcomes) {

		// Your code should replace the line below.
		Iterator<Outcome> iter = outcomes.listIterator();
		
		// Initializing the default result value
		boolean result = false;
		
		while (iter.hasNext()) {
			Outcome outcome = iter.next();
			if (outcome.isTie()) {
				result = result || this.areTied(c2, outcome);
			} else {
				result = result || this.hasWon(c2, outcome);
			}
		}
		return result;
	}

	// GIVEN: 	a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// 			  the outcomes that are outranked by this competitor,
	// 			  without duplicates, in alphabetical order

	public List<String> outranks(List<Outcome> outcomes) {

		List<String> checked = new ArrayList<String>();
		checked.add(this.name());
		
		// get set of outranks for this competitor
		Set<String> outrankSet = outranksSet(this, outcomes, checked);
		
		// convert set to list
		List<String> outranks = new ArrayList<String>();
		outranks.addAll(outrankSet);
		
		// Sort the list
		Collections.sort(outranks);
		return outranks;
	}

	// GIVEN: 	a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// 			  the outcomes that outrank this competitor,
	// 			  without duplicates, in alphabetical order

	public List<String> outrankedBy(List<Outcome> outcomes) {

		List<String> checked = new ArrayList<String>();
		checked.add(this.name());

		// get set of outranks for this competitor
		Set<String> outrankedBySet = outrankedBySet(this, outcomes, checked);

		// convert set to list
		List<String> outrankedBy = new ArrayList<String>();
		outrankedBy.addAll(outrankedBySet);

		// Sort the list
		Collections.sort(outrankedBy);
		return outrankedBy;

	}

	// GIVEN:   a list of outcomes
	// RETURNS: a list of the names of all competitors mentioned by
	// 			  one or more of the outcomes, without repetitions, with
	// 			  the name of competitor A coming before the name of
	// 			  competitor B in the list if and only if the power-ranking
	// 			  of A is higher than the power ranking of B.

	public List<String> powerRanking(List<Outcome> outcomes) {

		// Stores all the competitors involved in the outcome list.
		List<Competitor> allCompetitors = getAllCompetitors(outcomes);
		
		// sort all competitors, based on their power ranking.
		Collections.sort(allCompetitors, 
				// GIVEN: 	two objects o1 and o2.
				// RETURNS: -1 iff c1 has a higher power ranking than c2
				//			  else returns 1.
				(o1, o2) -> {return powerRankCompare(o1, o2, outcomes);});
				
		List<String> powerRank = new ArrayList<String>();
		for(Competitor c: allCompetitors){
			powerRank.add(c.name());
		}
		return powerRank;
	}
	

	/*************************
	 **** HELPER METHODS ****
	 *************************/
	
	
	// GIVEN: 	a Competitor c, list of outcomes and list of strings
	// RETURNS: a set of the names of all competitors mentioned by
	// 			the outcomes that are outranked by competitor c,
	// 			without duplicates, in no order

	private Set<String> outranksSet(Competitor c, List<Outcome> outcomes, 
			List<String> checked) {
		// Used to iterate over the outcome list
		Iterator<Outcome> iter = outcomes.listIterator();

		// Used to store the competitors outranked by c
		Set<String> outranks = new HashSet<String>();

		while (iter.hasNext()) {
			// Current outcome
			Outcome outcome = iter.next();
			
			if (outcome.isTie()) {
				checkTieOutranks(c, outcome, checked, outranks, outcomes);
			} else {
				checkDefeatOutranks(c, outcome, checked, outranks, outcomes);
			}
		}
		return outranks;
	}
	
	// GIVEN: 	a Competitor c, list of outcomes and list of strings
	// RETURNS: a set of the names of all competitors mentioned by
	// 			the outcomes that outrank competitor c,
	// 			without duplicates, in alphabetical order

	private Set<String> outrankedBySet(Competitor c, List<Outcome> outcomes,
			List<String> checked) {
		// Used to iterate over the outcome list
		Iterator<Outcome> iter = outcomes.listIterator();
		
		// Used to store the competitors outranked by c
		Set<String> outrankedBy = new HashSet<String>();
		
		while (iter.hasNext()) {
			// Current outcome
			Outcome outcome = iter.next();
			
			if (outcome.isTie()) {
				checkTieOutrankedBy(c, outcome, checked, outrankedBy, outcomes);
			} else {
				checkDefeatOutrankedBy(c, outcome, checked, outrankedBy, outcomes);
			}
		}
		return outrankedBy;
	}
	
	// GIVEN: 	a Competitor c, an outcome t, list of strings checked, 
	//            a set of strings, and a list of outcomes.
	// WHERE:   t.isTie() is false and
	//          checked contains the name of competitors that 
	//			  have been checked for their outranks before c.
	// EFFECT:  updates the outrankedBy set, with the name of the other
	// 			  competitor in the tie outcome and all the competitors
	// 			  that it outranks, without duplicates.
	
	private void checkTieOutrankedBy(Competitor c, Outcome t, List<String> checked, 
			Set<String> outrankedBy, List<Outcome> outcomes){
		if (inTie(c, t)) {
			Competitor other = getOtherPlayer(c, t);
			if (checked.contains(other.name())) {
				outrankedBy.add(other.name());
			} else {
				outrankedBy.add(other.name());
				checked.add(other.name());
				Set<String> otherOutranks = outrankedBySet(other, outcomes, checked);
				outrankedBy.addAll(otherOutranks);
			}
		}
	}
	
	// GIVEN: 	a Competitor c, an outcome d, list of strings checked, 
	//            a set of strings, and a list of outcomes.
	// WHERE:   t.isTie() is false and
	//          checked contains the name of competitors that 
	//			  have been checked for their outranks before c.
	// EFFECT:  updates the outrankedBy set, with the name of the winner
	// 			  in the defeat outcome and all the competitors that it
	// 			  outranks, without duplicates.
	
	private void checkDefeatOutrankedBy(Competitor c, Outcome d, List<String> checked, 
			Set<String> outrankedBy, List<Outcome> outcomes){
		if (isLoser(c, d)) {
			Competitor other = d.winner();
			if (checked.contains(other.name())) {
				outrankedBy.add(other.name());
			} else {
				outrankedBy.add(other.name());
				checked.add(other.name());
				Set<String> otherOutranks = outrankedBySet(other, outcomes, checked);
				outrankedBy.addAll(otherOutranks);
			}
		}
	}

	// GIVEN: 	a Competitor c, an outcome t, list of strings checked, 
	//            a set of strings, and a list of outcomes.
	// WHERE:   t.isTie() is true and
	//          checked contains the name of competitors that 
	//			  have been checked for their outranks before c.
	// EFFECT:  updates the outranks set, with the name of the competitor other
	// 			  in the tie outcome and all the competitors that are
	// 			  outranked by competitor other, without duplicates.
	
	private void checkTieOutranks(Competitor c, Outcome t, List<String> checked, 
			Set<String> outranks, List<Outcome> outcomes) {
		if (inTie(c, t)) {
			
			// the other competitor of the outcome
			Competitor other = getOtherPlayer(c, t);
			
			if (checked.contains(other.name())) {
				outranks.add(other.name());
			} else {
				outranks.add(other.name());
				checked.add(other.name());
				Set<String> otherOutranks = outranksSet(other, outcomes, checked);
				outranks.addAll(otherOutranks);
			}
		}
	}
	
	// GIVEN: 	a Competitor c, an outcome d, list of strings checked, 
	//            a set of strings, and a list of outcomes..
	// WHERE:   t.isTie() is false and
	//          checked contains the name of competitors that 
	//			  have been checked for their outranks before c.
	// EFFECT:  updates the outranks set, with the name of the loser
	// 			  in the defeat outcome and all the competitors that are
	// 			  outranked by the loser, without duplicates.
	
	private void checkDefeatOutranks(Competitor c, Outcome d, List<String> checked, 
			Set<String> outranks, List<Outcome> outcomes){
		if (isWinner(c, d)) {
			Competitor other = d.loser();
			if (checked.contains(other.name())) {
				outranks.add(other.name());
			} else {
				outranks.add(other.name());
				checked.add(other.name());
				Set<String> otherOutranks = outranksSet(other, outcomes, checked);
				outranks.addAll(otherOutranks);
			}
		}
	}

	// GIVEN: 	a Competitor c, and Outcome o
	// RETURNS: a Competitor other than the given
	// 			  that has participated in the given outcome o.

	private Competitor getOtherPlayer(Competitor c, Outcome o) {
		Competitor tieFirst = o.first();
		Competitor tieSecond = o.second();
		if (c.name().equals(tieFirst.name()))
			return tieSecond;
		else
			return tieFirst;

	}

	// GIVEN: 	a Competitor c, and Outcome d
	// WHERE: 	d.isTie() is false.
	// RETURNS: true iff c is the winner
	// 			  in the given outcome d.

	private boolean isWinner(Competitor c, Outcome d) {
		return c.name().equals(d.winner().name());
	}

	// GIVEN: 	a Competitor c, and Outcome d
	// WHERE: 	d.isTie() is false.
	// RETURNS: true iff c is the loser
	// 			  in the given outcome d.

	private boolean isLoser(Competitor c, Outcome d) {
		return c.name().equals(d.loser().name());
	}

	// GIVEN: 	a Competitor c, and Outcome d
	// WHERE: 	d.isTie() is false.
	// RETURNS: true iff this competitor has defeated c
	// 			  in the given outcome d.

	private boolean hasWon(Competitor c, Outcome d) {
		return isWinner(this, d) && isLoser(c, d);
	}

	// GIVEN: 	a Competitor c, and Outcome t
	// WHERE: 	t.isTie() is true.
	// RETURNS: true iff c is one of the
	// 			  competitors in the given outcome t.

	private boolean inTie(Competitor c, Outcome t) {
		String tieFirst = t.first().name();
		String tieSecond = t.second().name();
		return c.name().equals(tieFirst) || c.name().equals(tieSecond);
	}

	// GIVEN: 	a Competitor c, and Outcome t
	// WHERE: 	t.isTie() is true.
	// RETURNS: true iff this competitor and c are the
	// 			  competitors in the given outcome t.

	private boolean areTied(Competitor c, Outcome t) {
		return inTie(this, t) && inTie(c, t);
	}
	
	// GIVEN: 	list of outcomes
	// RETURNS: the list of all competitors that participate
    //	          in at least one of the outcomes in the given list
    //	          without any repetitions.
	
	private List<Competitor> getAllCompetitors(List<Outcome> outcomes){
		Iterator<Outcome> iter = outcomes.listIterator();
		List<Competitor> allCompetitors = new ArrayList<Competitor>();
		while(iter.hasNext()){
			Outcome outcome = iter.next();
			Competitor first = outcome.first();
			Competitor second = outcome.second();
			if (!allCompetitors.contains(first)){
				allCompetitors.add(first);
			}
			if (!allCompetitors.contains(second)){
				allCompetitors.add(second);
			}
		}
		return allCompetitors;
	}
	
	// GIVEN: 	a Competitor, list of outcomes
	// RETURNS: the number of outcomes the given competitor has
	//			  participated.
	
	private int getAppearanceCount(Competitor c, List<Outcome> outcomes){
		int count = 0;
		for (Outcome o: outcomes){
			if (o.isTie()){
				if (inTie(c, o)){
					count += 1;
				}
			}else{
				if (isWinner(c, o) || isLoser(c, o)){
					count += 1;
				}
			}
		}
		return count;
	}
	
	// GIVEN: 	a Competitor, list of outcomes
	// RETURNS: the number of outcomes the given competitor has
	//            won or tied with another competitor.
	
	private int getVictoryCount(Competitor c, 
			List<Outcome> outcomes){
		int count = 0;
		for (Outcome o: outcomes){
			if (o.isTie()){
				if (inTie(c, o)){
					count += 1;
				}
			}else{
				if (isWinner(c, o)){
					count += 1;
				}
			}
		}
		return count;
	}
	
	// GIVEN: 	a Competitor, list of outcomes
	// RETURNS: the non-losing percentage of that competitor.
	
	private float getNonLosingPercentage(Competitor c, 
			List<Outcome> outcomes){
		float victories = getVictoryCount(c, outcomes);
		float appearances = getAppearanceCount(c, outcomes);
		return (victories/appearances) * 100;
	}

	// GIVEN: 	two Objects c1 and c2, list of outcomes
	// RETURNS: -1 iff c1 has a higher power ranking than c2
	//			  else returns 1.
	
	private int powerRankCompare(Object c1, Object c2, 
			List<Outcome> outcomes){
		Competitor o1 = (Competitor)c1;
		Competitor o2 = (Competitor)c2;
		int o1Outranks = o1.outranks(outcomes).size();
		int o2Outranks = o2.outranks(outcomes).size();
		int o1Outranked = o1.outrankedBy(outcomes).size();
		int o2Outranked = o2.outrankedBy(outcomes).size();
		float o1Nlp = getNonLosingPercentage(o1, outcomes);
		float o2Nlp = getNonLosingPercentage(o2, outcomes);
		if (o1Outranked < o2Outranked)
			return -1;
		else if(o1Outranked > o2Outranked)
			return 1;
		else if (o1Outranks > o2Outranks)
			return -1;
		else if(o1Outranks < o2Outranks)
			return 1;
		else if (o1Nlp > o2Nlp)
			return -1;
		else if(o1Nlp < o2Nlp)
			return 1;
		else
			return o1.name().compareTo(o2.name());
	}

	// You may define help methods here.
	// You may also define a main method for testing.
}
