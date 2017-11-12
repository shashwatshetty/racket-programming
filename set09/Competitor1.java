// Constructor template for Competitor1:
//     new Competitor1 (Competitor c1)
//
// Interpretation: the competitor represents an individual or team

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.
import java.util.List;
import java.util.*;

// You may import other interfaces and classes here.

class Competitor1 implements Competitor {

    // You should define your fields here.
	String competitorName;

    Competitor1 (String s) {

        // Your code goes here.
    	this.competitorName = s;

    }

    // returns the name of this competitor

    public String name () {

        // Your code goes here.
    	return this.competitorName;

    }

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor

    public boolean hasDefeated (Competitor c2, List<Outcome> outcomes) {

        // Your code should replace the line below.
    	Iterator<Outcome> iter = outcomes.listIterator();
    	boolean result = false;
		while(iter.hasNext()){
			Outcome outcome = iter.next();
			if(outcome.isTie()){
				result = result || this.areTied(c2, outcome);
			}
			else{
				result = result || this.hasWon(c2, outcome);
			}
		}
		return result;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that are outranked by this competitor,
    //     without duplicates, in alphabetical order

    public List<String> outranks (List<Outcome> outcomes) {

        // Your code should replace the line below.
    	List<String> checked = new ArrayList<String>();
		checked.add(this.name());
		Set<String> outrankSet = outranksSet(this, outcomes, checked);
		List <String> outranks = new ArrayList<String>();
		outranks.addAll(outrankSet);
		Collections.sort(outranks);
		return outranks;
        //throw new UnsupportedOperationException();

    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order

    public List<String> outrankedBy (List<Outcome> outcomes) {

        // Your code should replace the line below.
    	List<String> checked = new ArrayList<String>();
		checked.add(this.name());
		Set<String> outrankedBySet = outrankedBySet(this, outcomes, checked);
		List <String> outrankedBy = new ArrayList<String>();
		outrankedBy.addAll(outrankedBySet);
		Collections.sort(outrankedBy);
		return outrankedBy;
        //throw new UnsupportedOperationException();

    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.

    public List<String> powerRanking (List<Outcome> outcomes) {

        // Your code should replace the line below.

        throw new UnsupportedOperationException();

    }
    
    /*************************
    ****  HELPER METHODS  ****
    *************************/
    public Set<String> outranksSet(Competitor c, List<Outcome> outcomes, List<String> checked){
    	Iterator<Outcome> iter = outcomes.listIterator();
    	Set<String> outranks = new HashSet<String>();
    	while(iter.hasNext()){
    		Outcome outcome = iter.next();
    		if (outcome.isTie()){
    			if (inTie(c, outcome)){
    				Competitor other = getOtherPlayer(c, outcome);
    				if (checked.contains(other.name())){
    					outranks.add(other.name());
    				}
    				else{
    					outranks.add(other.name());
    					checked.add(other.name());
        				Set <String> otherOutranks = outranksSet(other, outcomes, checked);
        				outranks.addAll(otherOutranks);
    				}
    			}
    		}
    		else{
    			if(isWinner(c, outcome)){
    				Competitor other = outcome.loser();
    				if (checked.contains(other.name())){
    					outranks.add(other.name());
    				}
    				else{
    					outranks.add(other.name());
    					checked.add(other.name());
        				Set <String> otherOutranks = outranksSet(other, outcomes, checked);
        				outranks.addAll(otherOutranks);
    				}
    			}
    		}
    	}
    	return outranks;
    }
    
    public Set<String> outrankedBySet(Competitor c, List<Outcome> outcomes, List<String> checked){
    	Iterator<Outcome> iter = outcomes.listIterator();
    	Set<String> outrankedBy = new HashSet<String>();
    	while(iter.hasNext()){
    		Outcome outcome = iter.next();
    		if (outcome.isTie()){
    			if (inTie(c, outcome)){
    				Competitor other = getOtherPlayer(c, outcome);
    				if (checked.contains(other.name())){
    					outrankedBy.add(other.name());
    				}
    				else{
    					outrankedBy.add(other.name());
    					checked.add(other.name());
        				Set <String> otherOutranks = 
        						outrankedBySet(other, outcomes, checked);
        				outrankedBy.addAll(otherOutranks);
    				}
    			}
    		}
    		else{
    			if(isLoser(c, outcome)){
    				Competitor other = outcome.winner();
    				if (checked.contains(other.name())){
    					outrankedBy.add(other.name());
    				}
    				else{
    					outrankedBy.add(other.name());
    					checked.add(other.name());
        				Set <String> otherOutranks = 
        						outrankedBySet(other, outcomes, checked);
        				outrankedBy.addAll(otherOutranks);
    				}
    			}
    		}
    	}
    	return outrankedBy;
    }
    
    public Competitor getOtherPlayer(Competitor c, Outcome o){
    	Competitor tieFirst = o.first();
    	Competitor tieSecond = o.second();
    	if (c.name().equals(tieFirst.name()))
    		return tieSecond;
    	else
    		return tieFirst;
    	
    }
    
    public boolean isWinner(Competitor c, Outcome d){
    	return c.name().equals(d.winner().name());
    }
    

    public boolean isLoser(Competitor c, Outcome d){
    	return c.name().equals(d.loser().name());
    }
    
    public boolean hasWon(Competitor c, Outcome d){
    	return isWinner(this, d) && isLoser(c, d);
    }
    
    public boolean inTie(Competitor c, Outcome t){
    	String tieFirst = t.first().name();
    	String tieSecond = t.second().name();
    	return c.name().equals(tieFirst) || c.name().equals(tieSecond);
    }
    
    public boolean areTied(Competitor c, Outcome t){
    	return inTie(this, t) && inTie(c, t);
    }

    // You may define help methods here.
    // You may also define a main method for testing.
    public static void main (String args[]){
    	Competitor1 A = new Competitor1("A");
    	Competitor1 B = new Competitor1("B");
    	Competitor1 C = new Competitor1("C");
    	Competitor1 D = new Competitor1("D");
		Defeat1 AdefB = new Defeat1(A,B);
		Defeat1 BdefC = new Defeat1(B,C);
		Defeat1 CdefD = new Defeat1(C,D);
		Tie1 AtieD = new Tie1(A,D);
		List<Outcome> outcomes = new ArrayList<Outcome>();
		outcomes.add(AdefB);
		outcomes.add(BdefC);
		//outcomes.add(new Defeat1(A,D));
		outcomes.add(CdefD);
		//outcomes.add(AtieD);
		System.out.println("D outranks: "+D.outranks(outcomes));
		System.out.println("D outranked by: "+D.outrankedBy(outcomes));
		//System.out.println("Winner of A defeated B is: "+BdefC.winner().name());
		//System.out.println("has A defeated B?: "+C.hasDefeated(D, outcomes));
    }
}
