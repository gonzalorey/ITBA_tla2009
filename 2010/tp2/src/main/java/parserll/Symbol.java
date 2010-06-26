package parserll;

public class Symbol implements SpecialSymbols {

	
	private char symbol;
	
	public static Symbol[] getArrayOfSymbols(String str){
		char[] symbols = str.toCharArray();
		Symbol[] ret = new Symbol[symbols.length];
		
		for(int i = 0 ; i < symbols.length ; i++){
			ret[i] = new Symbol(symbols[i]);
		}
		return ret;
		
	}
	
	public static Symbol getEndMark(){
		return new Symbol(Symbol.END_OF_STRING_MARK);
	}
	
	public static Symbol getLambda(){
		return new Symbol(Symbol.LAMBDA);
	}
	                     
	public boolean isTerminal(){
		return !Character.isUpperCase(symbol);
	}
	
	
	public Symbol(char symbol){
		this.symbol = symbol;
	}
	
	public char getSymbol(){
		return symbol;
	}
	
	public String toString(){
		return Character.toString(symbol);
	}
	
	
	public boolean isLambda() {
		return symbol == LAMBDA;
	}
	
	public boolean isEndOfString(){
		return symbol == END_OF_STRING_MARK;
	}
	
	public boolean equals(Object o){
		if(o == null)
			return false;
		
		if(this == o)
			return true;
		
		if(!(o instanceof Symbol))
			return false;
		
		return ((Symbol)o).symbol == symbol;
		
	}
	
}
