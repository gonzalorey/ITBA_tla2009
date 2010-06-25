package parserll;

public class Simbol implements SpecialSimbols {

	
	private char simbol;
	
	public static Simbol[] getArrayOfSimbols(String str){
		char[] simbols = str.toCharArray();
		Simbol[] ret = new Simbol[simbols.length];
		
		for(int i = 0 ; i < simbols.length ; i++){
			ret[i] = new Simbol(simbols[i]);
		}
		return ret;
		
	}
	
	public static Simbol getEndMark(){
		return new Simbol(Simbol.END_OF_STRING_MARK);
	}
	
	public static Simbol getLambda(){
		return new Simbol(Simbol.LAMBDA);
	}

	                     
	public boolean isTerminal(){
		return !Character.isUpperCase(simbol);
	}
	
	
	public Simbol(char simbol){
		this.simbol = simbol;
	}
	
	public char getSimbol(){
		return simbol;
	}
	
	public String toString(){
		return Character.toString(simbol);
	}
	
	
	public boolean isLambda() {
		return simbol == LAMBDA;
	}
	
	public boolean isEndOfString(){
		return simbol == END_OF_STRING_MARK;
	}
	
	public boolean equals(Object o){
		if(o == null)
			return false;
		
		if(this == o)
			return true;
		
		if(!(o instanceof Simbol))
			return false;
		
		return ((Simbol)o).simbol == simbol;
		
	}
	
	
}
