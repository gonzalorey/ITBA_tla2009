package parserll;

public class Production {

	private Symbol leftPart;
	private Symbol[] rightPart;
	
	
	public Production(Symbol leftPart, Symbol[] rightPart){
		this.leftPart = leftPart;
		this.rightPart = rightPart;
	}
	
	
	public Symbol getLeftPart(){
		return leftPart;
	}
	
	public Symbol[] getRightPart(){
		return rightPart;
	}
	

	public String toString(){
		
		String rPart = "";
		
		for(Symbol b: rightPart){
			rPart += b.toString();
		}
		
		return leftPart.toString() + "->" + rPart; 		
		
	}
	
}
