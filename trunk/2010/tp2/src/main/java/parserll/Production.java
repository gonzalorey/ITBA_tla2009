package parserll;

public class Production {

	private Simbol leftPart;
	private Simbol[] rightPart;
	
	
	public Production(Simbol leftPart, Simbol[] rightPart){
		this.leftPart = leftPart;
		this.rightPart = rightPart;
	}
	
	
	public Simbol getLeftPart(){
		return leftPart;
	}
	
	public Simbol[] getRightPart(){
		return rightPart;
	}
	

	public String toString(){
		
		String rPart = "";
		
		for(Simbol b: rightPart){
			rPart += b.toString();
		}
		
		return leftPart.toString() + "->" + rPart; 		
		
	}
	
}
