package parserll;

public class InputString {

	private char[] string;
	private int index = 0;
	
	
	
	public InputString(String string){
		this.string = (string + SpecialSimbols.END_OF_STRING_MARK).toCharArray(); 
	}
	
	
	public Simbol getSimbol(){
		return new Simbol(string[index]);
	}
	
	public void nextSimbol(){
		index++;
	}
	
}
