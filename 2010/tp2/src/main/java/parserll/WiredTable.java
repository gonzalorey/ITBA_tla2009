package parserll;

import java.util.InputMismatchException;
import java.util.NoSuchElementException;

public class WiredTable implements Table {

	
	/**
	 * Esta tabla informa las producciones a seguir para la gramática
	 * S->(S)
	 * S->a
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
