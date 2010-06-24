package parserll;

import java.util.LinkedList;

public class Stack {

	private LinkedList<Simbol> stack = new LinkedList<Simbol>();
	
	public Stack(Simbol[] initialStack){
		this();

		push(initialStack);
		
	}
	
	public Stack(){
	}
	
	
	
	
	public void push(Simbol s){
		stack.push(s);
	}
	

	public void push(Simbol[] s){
		
		for(int i = s.length - 1 ; i  >= 0 ; i--){
			push(s[i]);
		}
		
	}
	
	public Simbol pop(){
		return stack.pop();
	}
	
	
}
