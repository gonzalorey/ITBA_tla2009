package parserll;

import java.util.NoSuchElementException;

public class Parser {

	
	private Table predictionTable;
	
	
	public Parser(Table predictionTable){
		this.predictionTable = predictionTable;
	}
	
	
	public boolean belongs(String string){
		
		Stack stack = new Stack(Simbol.getArrayOfSimbols("S#"));
		InputString input = new InputString(string);
		
		
		try {
			
			while(true){
				
				Simbol top = stack.pop();
				
				if(top.isTerminal()){
	
					if(!top.equals(input.getSimbol()))
						return false;
					else if (!top.equals(Simbol.getEndMark()))
						input.nextSimbol();
					else
						return true;
				} else {
					
					Simbol[] rightPart = predictionTable.getRightPart(top, input.getSimbol());
					
					if(!(rightPart.length == 1 && rightPart[0].equals(Simbol.getLambda())))
						stack.push(rightPart);
				}
			}
		} catch(NoSuchElementException e){
			return false;
		}
	}		
	
}
