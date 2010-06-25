package parserll;

import java.util.HashMap;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

public class PredictionTable implements Table {

	private Map<Simbol, Simbol[]> table = new HashMap<Simbol, Simbol[]>(); 
	
	public PredictionTable(List<Production> productions){
		for(Production p : productions){
			table.put(p.getLeftPart(), p.getRightPart());
		}
	}
	
	/**
	 * Esta tabla informa las producciones a seguir para la gramtica
	 */
	
	@Override
	public Simbol[] getRightPart(Simbol stackSimbol, Simbol stringSimbol) {

		if(stackSimbol.isTerminal() || !stringSimbol.isTerminal()){
			throw new InputMismatchException("stackSimbol can not be terminal and stringSimbol nor not terminal");
		}
		
		if(stackSimbol.getSimbol() == 'S'){
			if (stringSimbol.getSimbol() == '('){
				return Simbol.getArrayOfSimbols("(S)");
			} else if(stringSimbol.getSimbol() == 'a'){
				return Simbol.getArrayOfSimbols("a");
			}
		}
		throw new NoSuchElementException("There is not a right part for this convination");
	}

	
}
