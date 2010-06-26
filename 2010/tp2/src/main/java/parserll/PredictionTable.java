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
		
		//fill the table with the productions 
//		for(Production p : productions){
//			stack = new Symbol(p.getLeftPart().getSymbol());
//			string = new Symbol(p.getRightPart()[0].getSymbol());
//			table.put(new TableKey(string, stack), p.getRightPart());
//		}
		
		for(Production p : productions){
			stack = new Symbol(p.getLeftPart().getSymbol());
			string = new Symbol(p.getRightPart()[0].getSymbol());
			key = new TableKey(string, stack); 
			
			//if it was already put (with a null value), remove it
			if(table.get(key) != null)
				table.remove(key);
				
			//insert the original
			table.put(new TableKey(string, stack), p.getRightPart());
			
			//insert the rest of the values
			for(int i = 1; i < p.getRightPart().length; i++){
				string = new Symbol(p.getRightPart()[i].getSymbol());
				key = new TableKey(string, stack);
				
				//in this case, ONLY if it's null put it...
				if(table.get(key) == null)
					table.put(key, Symbol.getArrayOfSymbols(""));
			}
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
		
		//if its a null value, return null, else the answer
		return ans;
	}
}
