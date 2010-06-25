package parserll;


public class TableKey implements Comparable<TableKey>{

	//Symbol from the string
	private Symbol stringSymbol;
	
	//Symbol from the stack
	private Symbol stackSymbol;
	
	public TableKey(Symbol stringSymbol, Symbol stackSymbol){
		this.stringSymbol = stringSymbol;
		this.stackSymbol = stackSymbol;
	}
	
	public Symbol getStringSymbol() {
		return stringSymbol;
	}
	
	public void setStringSymbol(Symbol stringSymbol) {
		this.stringSymbol = stringSymbol;
	}
	
	public Symbol getStackSymbol() {
		return stackSymbol;
	}
	
	public void setStackSymbol(Symbol stackSymbol) {
		this.stackSymbol = stackSymbol;
	}
	
	@Override
	public boolean equals(Object obj){
		if(obj == null)
			return false;
		
		if(this == obj)
			return true;
		
		if(!(obj instanceof TableKey))
			return false;
		
		TableKey t = (TableKey) obj;
		return t.getStringSymbol().equals(this.stringSymbol) && t.getStackSymbol().equals(this.stackSymbol);
	}
	
	@Override
	public int hashCode() {
		return this.stringSymbol.hashCode() + this.stackSymbol.hashCode();
	}

	@Override
	public int compareTo(TableKey obj) {
		if(obj.getStackSymbol().getSymbol() > this.stackSymbol.getSymbol())
			return 1;
		if(obj.getStackSymbol().getSymbol() < this.stackSymbol.getSymbol())
			return -1;
		if(obj.getStringSymbol().getSymbol() > this.stringSymbol.getSymbol())
			return 1;
		if(obj.getStringSymbol().getSymbol() > this.stringSymbol.getSymbol())
			return -1;
		return 0;
	}
}
