package parserll;


public class TableKey implements Comparable<TableKey>{

	//Symbol from the string
	private Simbol stringSimbol;
	
	//Symbol from the stack
	private Simbol stackSimbol;
	
	public TableKey(Simbol stringSimbol, Simbol stackSimbol){
		this.stringSimbol = stringSimbol;
		this.stackSimbol = stackSimbol;
	}
	
	public Simbol getStringSimbol() {
		return stringSimbol;
	}
	
	public void setStringSimbol(Simbol stringSimbol) {
		this.stringSimbol = stringSimbol;
	}
	
	public Simbol getStackSimbol() {
		return stackSimbol;
	}
	
	public void setStackSimbol(Simbol stackSimbol) {
		this.stackSimbol = stackSimbol;
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
		return t.getStringSimbol().equals(this.stringSimbol) && t.getStackSimbol().equals(this.stackSimbol);
	}
	
	@Override
	public int hashCode() {
		return this.stringSimbol.hashCode() + this.stackSimbol.hashCode();
	}

	@Override
	public int compareTo(TableKey obj) {
		if(obj.getStackSimbol().getSimbol() > this.stackSimbol.getSimbol())
			return 1;
		if(obj.getStackSimbol().getSimbol() < this.stackSimbol.getSimbol())
			return -1;
		if(obj.getStringSimbol().getSimbol() > this.stringSimbol.getSimbol())
			return 1;
		if(obj.getStringSimbol().getSimbol() > this.stringSimbol.getSimbol())
			return -1;
		return 0;
	}
}
