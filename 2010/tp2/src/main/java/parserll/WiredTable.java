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
	public Symbol[] getRightPart(Symbol stackSymbol, Symbol stringSymbol) {

		if(stackSymbol.isTerminal() || !stringSymbol.isTerminal()){
			throw new InputMismatchException("stackSymbol can not be terminal and stringSymbol nor not terminal");
		}
		
		if(stackSymbol.getSymbol() == 'S'){
			if (stringSymbol.getSymbol() == '('){
				return Symbol.getArrayOfSymbols("(S)");
			} else if(stringSymbol.getSymbol() == 'a'){
				return Symbol.getArrayOfSymbols("a");
			}
		}
		throw new NoSuchElementException("There is not a right part for this convination");
	}

	
}
