package parserll;

import java.util.LinkedList;

public class Stack {

	private LinkedList<Symbol> stack = new LinkedList<Symbol>();
	
	public Stack(Symbol[] initialStack){
		this();

		push(initialStack);
		
	}
	
	public Stack(){
	}
	
	
	
	
	public void push(Symbol s){
		stack.push(s);
	}
	

	public void push(Symbol[] s){
		
		for(int i = s.length - 1 ; i  >= 0 ; i--){
			push(s[i]);
		}
		
	}
	
	public Symbol pop(){
		return stack.pop();
	}
	
	
}
