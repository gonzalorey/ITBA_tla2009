package parserll;

import java.util.LinkedList;
import java.util.List;

public class Grammar {

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
		return name;
	}
	
	public PredictionTable getPredictionTable(){
		return new PredictionTable(productions);
	}
	
}
