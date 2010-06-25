package parserll;

import java.util.InputMismatchException;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.TreeMap;

public class PredictionTable implements Table {

	private Map<TableKey, Symbol[]> table = new TreeMap<TableKey, Symbol[]>(); 
	
	public PredictionTable(List<Production> productions){
		
		Symbol string, stack;
		
		for(Production p : productions){
			stack = new Symbol(p.getLeftPart().getSymbol());
			string = new Symbol(p.getRightPart()[0].getSymbol());
			table.put(new TableKey(string, stack), p.getRightPart());
		}
	}
	
	@Override
	public Symbol[] getRightPart(Symbol stackSymbol, Symbol stringSymbol) {

		if(stackSymbol.isTerminal() || !stringSymbol.isTerminal()){
			throw new InputMismatchException("stackSymbol cannot be terminal and stringSymbol either");
		}
	
		//load the symbols
		Symbol string = new Symbol(stringSymbol.getSymbol());
		Symbol stack = new Symbol(stackSymbol.getSymbol());

		//get the value from the table
		Symbol[] ans = table.get(new TableKey(string, stack));
		
		if(ans == null)
			throw new NoSuchElementException("There isn't a right part for this conbination");
		
		return ans;
	}
}
