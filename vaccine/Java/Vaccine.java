import java.util.*;
import java.io.*;

public class Vaccine{
    public static void main(String args[]) throws Exception {
        File f = new File(args[0]);
        Scanner scan = new Scanner(f);
        int Q = scan.nextInt();
        
        for (int i=0; i<Q; i++){
            
            String inp = scan.next();
            StringBuilder temp = new StringBuilder();
            temp.append(inp);
            temp = temp.reverse();
            String rna = temp.toString();
            String comp = complement(rna);

            Solver solver = new VaccSolver();

            char ch = rna.charAt(0);
            HashSet<Character> group = new HashSet<Character>() ;
            group.add(ch);
            State initial = new VaccState(rna, comp, 1, true, ch, ch, 'p', group, null);
            
            State result = solver.solve(initial);
            printSolution(result);
            System.out.println();
        }  
        scan.close(); 
    }

    private static String complement(String rna){
        StringBuilder temp = new StringBuilder();
        char[] chars = rna.toCharArray();
        for (char ch : chars) {
            if (ch == 'A')
                temp.append('U');
            else if (ch == 'U')
                temp.append('A');
            else if (ch == 'C')
                temp.append('G');
            else if (ch == 'G')
                temp.append('C');
        }
        return temp.toString();
    }


        // A recursive function to print the states from the initial to the final.
    private static void printSolution(State s) {
        if (s != null) {
            printSolution(s.getPrevious());
            System.out.print(s);
        }
    }


}