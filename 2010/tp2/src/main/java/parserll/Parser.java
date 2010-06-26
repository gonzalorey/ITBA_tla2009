package parserll;

import java.util.NoSuchElementException;

public class Parser {

	
	private Table predictionTable;
	
	
	public Parser(Table predictionTable){
		this.predictionTable = predictionTable;
	}
	
	
	public boolean belongs(String string){
		
		Stack stack = new Stack(Symbol.getArrayOfSymbols("S#"));
		InputString input = new InputString(string);
		
		System.out.println("Prediction Table: \n" +  predictionTable);
		
		try {
			
			while(true){
				
				Symbol top = stack.pop();
				
				if(top.isTerminal()){
	
					if(!top.equals(input.getSymbol()))
						return false;
					else if (!top.equals(Symbol.getEndMark()))
						input.nextSymbol();
					else
						return true;
				} else {
					
					Symbol[] rightPart = predictionTable.getRightPart(top, input.getSymbol());
					
					if(!(rightPart.length == 1 && rightPart[0].equals(Symbol.getLambda())))
						stack.push(rightPart);
				}
			}
		} catch(NoSuchElementException e){
			return false;
		}
	}		
	
}
