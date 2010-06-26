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


		if(args.length != 2){
			System.out.println("Wrong usage");
			System.out.println("Use:");
			System.out.println("$> java -jar parserll.jar <gramarfile> <string>");
			System.out.println("\nExample: $> java -jar parserll.jar  anbn aaabbb\n");
			System.exit(1);
		}
		
		String filename = args[0];
		String string = args[1];
		
		BufferedReader in = new BufferedReader(new FileReader(filename));
		
		Grammar grammar = new Grammar(filename);
		
		Grammar.populateProductions(grammar, in);
		
		in.close();
		
		System.out.println("Grammar '" + grammar.getName() + "' loaded...\n");
		System.out.println("Productions:\n" + grammar.getProductionsString() + "\n");
		
		
		Parser parser = new Parser(grammar.getPredictionTable());
		
		System.out.println("The string \"" + string + "\" " + ((parser.belongs(string))? "":"doesn't ") + "belongs to the language");
		

	}

}
