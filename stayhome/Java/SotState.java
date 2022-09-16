import java.util.*;

public class SotState{
    public int x, y, t, N, M;
    public char dir;
    public char[][] world;
    public HashMap<Integer, Integer> time; 
    public SotState previous;
    
    public SotState(int x, int y, int t, int N, int M, char[][] world, HashMap<Integer, Integer> time, char dir, SotState previous){
        this.x = x;
        this.y = y;
        this.dir = dir;
        this.previous = previous;
        this.t = t;
        this.time = time;
        this.world = world;
        this.N = N;
        this.M = M;

    }

    public SotState(int x, int y, char dir, SotState previous){
        this.x = x;
        this.y = y;
        this.dir = dir;
        this.previous = previous;

        this.t = previous.t + 1;
        this.time = previous.time;
        this.world = previous.world;
        this.N = previous.N;
        this.M = previous.M;

    }

    public int pos(){
        return x*M + y;
    }

    public boolean isFinal() {
        return world[x][y] == 'T';
    }

    public boolean isValid() {
        return (x >= 0) && (x < N) && (y >=0) && (y < M) && (world[x][y] == '.' || world[x][y] == 'A' || world[x][y] == 'T') && safe();
    }

    private boolean safe(){
        int pos = pos();
        return (!time.containsKey(pos) || (time.get(pos) > t));
    }

    public Collection<SotState> next(){
        Collection<SotState> states = new ArrayList<>();
        states.add(new SotState(x+1, y, 'D', this));
        states.add(new SotState(x, y-1, 'L', this));
        states.add(new SotState(x, y+1, 'R', this));
        states.add(new SotState(x-1, y, 'U', this));
        
        return states;
    }

    public SotState getPrevious(){
        return previous;
    }

    public char getDir(){
        return dir;
    }

    @Override
    public String toString() {
      return String.valueOf(dir);
    }

    @Override
    public boolean equals(Object o){
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SotState other = (SotState) o;
        return (x == other.x && y ==other.y);
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}