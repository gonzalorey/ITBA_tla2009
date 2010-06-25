package parserll;

import java.util.InputMismatchException;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.TreeMap;

public class PredictionTable implements Table {

	private Map<TableKey, Simbol[]> table = new TreeMap<TableKey, Simbol[]>(); 
	
	public PredictionTable(List<Production> productions){
		
		Simbol string, stack;
		
		for(Production p : productions){
			stack = new Simbol(p.getLeftPart().getSimbol());
			string = new Simbol(p.getRightPart()[0].getSimbol());
			table.put(new TableKey(string, stack), p.getRightPart());
		}
	}
	
	@Override
	public Simbol[] getRightPart(Simbol stackSimbol, Simbol stringSimbol) {

		if(stackSimbol.isTerminal() || !stringSimbol.isTerminal()){
			throw new InputMismatchException("stackSimbol cannot be terminal and stringSimbol either");
		}
	
		//load the simbols
		Simbol string = new Simbol(stringSimbol.getSimbol());
		Simbol stack = new Simbol(stackSimbol.getSimbol());

		//get the value from the table
		Simbol[] ans = table.get(new TableKey(string, stack));
		
		if(ans == null)
			throw new NoSuchElementException("There isn't a right part for this conbination");
		
		return ans;
	}
}
