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
		TableKey key;
		
		for(Production p : productions){
			stack = new Symbol(p.getLeftPart().getSymbol());
			string = new Symbol(p.getRightPart()[0].getSymbol());
			key = new TableKey(string, stack); 
			
			table.put(key, p.getRightPart());
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
		
		if(ans == null){
			if(!stringSymbol.isTerminal())
				throw new NoSuchElementException("There isn't a right part for this conbination");
			else
				ans = Symbol.getArrayOfSymbols("");
		}
			
		
		//if its a null value, return null, else the answer
		return ans;
	}
	
	@Override
	public String toString() {
		String ans = "";
		
		for(TableKey key : table.keySet()){
			ans += key + ":";
			
			if(table.get(key).length == 0){
					ans += "_";
			}else{
				for(int i = 0; i < table.get(key).length; i++)
					ans += table.get(key)[i];
			}
			
			ans += "\n";
		}
		
		return ans;
	}
}
