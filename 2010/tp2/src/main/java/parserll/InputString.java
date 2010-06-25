package parserll;

public class InputString {

	private char[] string;
	private int index = 0;
	
	
	
	public InputString(String string){
		this.string = (string + SpecialSymbols.END_OF_STRING_MARK).toCharArray(); 
	}
	
	
	public Symbol getSymbol(){
		return new Symbol(string[index]);
	}
	
	public void nextSymbol(){
		index++;
	}
	
}
