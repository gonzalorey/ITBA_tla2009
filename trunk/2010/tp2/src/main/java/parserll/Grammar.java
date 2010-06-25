package parserll;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

public class Grammar {

	
	public static void populateProductions(Grammar grammar, BufferedReader reader) throws IOException{
		
		String line;

		while((line = reader.readLine()) != null){
			String[] parts = line.split(" ");
			
			Symbol rigthPart = new Symbol(parts[0].toCharArray()[0]);
			
			Symbol[] leftPart = null;
			
			if(parts.length == 2){
				leftPart = Symbol.getArrayOfSymbols(parts[1]);
			}
			else{
				leftPart = new Symbol[1];
				leftPart[0] = Symbol.getLambda();
			}
			
			Production prod = new Production(rigthPart, leftPart); 
			
			grammar.addProduction(prod);
			
			
		}	
		
	}
	
	private String name;
	private List<Production> productions = new LinkedList<Production>();


	public Grammar(){
		this("aGrammar");
	}
	
	
	public Grammar(String name){
		this.name = name;
	}
	
	public void addProduction(Production production) {
		productions.add(production);
	}
	
	public String toString(){
		String ret = "";
		String sep = "";
		ret += name;
		
		ret += "=<{";
		
		for(Production p: productions){
			ret += sep;
			ret += p;
			sep = ",";
		}

		ret += "}>";
		
		return ret;
	}
	
	public PredictionTable getPredictionTable(){
		return new PredictionTable(productions);
	}
	
}
