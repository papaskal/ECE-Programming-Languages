import java.util.*;

public class VirusState{
    public int x, y, t, N, M;
    public char[][] world;
    
    public VirusState(int x, int y, int t, int N, int M, char[][] world){
        this.x = x;
        this.y = y;
        this.t = t;
        this.world = world;
        this.N = N;
        this.M = M;
    }


    public VirusState(int x, int y, VirusState previous){
        this.x = x;
        this.y = y;

        this.t = previous.t + 2;
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

    public boolean isAir() {
        return world[x][y] == 'A';
    }

    public boolean isValid() {
        return (x >= 0) && (x < N) && (y >=0) && (y < M) && (world[x][y] != 'X');
    }

    public Collection<VirusState> next(){
        Collection<VirusState> VirusStates = new ArrayList<>();
        VirusStates.add(new VirusState(x+1, y, this));
        VirusStates.add(new VirusState(x, y-1, this));
        VirusStates.add(new VirusState(x, y+1, this));
        VirusStates.add(new VirusState(x-1, y, this));
        
        return VirusStates;
    }


    @Override
    public boolean equals(Object o){
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VirusState other = (VirusState) o;
        return (x == other.x && y ==other.y);
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}