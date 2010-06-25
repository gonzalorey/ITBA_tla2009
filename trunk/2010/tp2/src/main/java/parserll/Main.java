package parserll;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;



public class Main {

	/**
	 * @param args
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException, IOException {

		
		String cadena = "((a))";
		
		String filename = "test.txt";
		BufferedReader in = new BufferedReader(new FileReader(filename));
		
		Grammar grammar = new Grammar("myGrammar");
		
		Grammar.populateProductions(grammar, in);
		
		
		in.close();
		
		
		System.out.println(grammar);
		
		Parser parser = new Parser(new WiredTable());
		
		
		System.out.println("La cadena \"" + cadena + "\" " + ((parser.belongs(cadena))? "":"no ") + "pertenece al lenguaje");
		

	}

}
