import java.util.*;
import java.io.*;

public class StayHome{

    private static int N;
    private static int M;
    private static char[][] world;

    public static void main(String args[]) throws Exception {
        readInput(args[0]);

        StayHomeSolver solver = new StayHomeSolver();
        SotState result = solver.solve(N, M, world);
        
        if (result == null) {
            System.out.println("IMPOSSIBLE");
        }
        else {    
            printSolution(result);
        }
    }

   private static void printSolution(SotState s) {
        StringBuilder temp = new StringBuilder();
        while (s.getPrevious() != null) {
            temp.append(s.toString());
            s = s.getPrevious();
        }
        System.out.println(temp.length());
        System.out.println(temp.reverse());
    }

    public static void readInput(String file) throws Exception {
        ArrayList <ArrayList <Character> > bas = new ArrayList<>();
        bas.add(new ArrayList<>());

        FileReader fr = new FileReader(file);
        int x;
        x = 0;
        int c = 0;
        char ch;
        while ((c = fr.read()) != -1){
            ch = (char) c;
            if (ch == '\n'){
                bas.add(new ArrayList<>());
                x++;
            }
            else {
                bas.get(x).add(ch);
            }
        }

        N = bas.size()-1;
        M = bas.get(0).size();

        world = new char[N][M];
        for (int i=0; i<N; i++)
            for (int j=0; j<M; j++)
                world[i][j] = bas.get(i).get(j);
    }

}