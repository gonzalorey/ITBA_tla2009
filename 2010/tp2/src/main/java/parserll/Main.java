package parserll;



public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		
		String cadena = "((a))";
		Parser parser = new Parser(new WiredTable());
		
		
		System.out.println("La cadena \"" + cadena + "\" " + ((parser.belongs(cadena))? "":"no ") + "pertenece al lenguaje");
		

	}

}
