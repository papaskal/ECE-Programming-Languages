import java.util.*;

 
public class StayHomeSolver {
  
  public SotState solve (int N, int M, char[][] world) {

   
    VirusState virusSrc = null;
    for (int i=0; i<N; i++){
      for (int j=0; j<M; j++){
        if (world[i][j] == 'W')
          virusSrc = new VirusState(i, j, 0, N, M, world);
      }
    }

    int pos;
    HashMap<Integer, Integer> seen = new HashMap<>();
    Queue<VirusState> remaining = new ArrayDeque<>();
    remaining.add(virusSrc);
    seen.put(virusSrc.pos(), 0);
    
    VirusState s = null;
    while (!remaining.isEmpty()) {
      s = remaining.remove();
      for (VirusState n : s.next()){
        pos = n.pos();
        if (!seen.containsKey(pos) && n.isValid()){
          remaining.add(n);
          seen.put(pos, n.t);
        }
      }
      if (s.isAir()){
        break;
      }
    }

    

    if (s.isAir()) {
      int t = s.t;

      if (!remaining.isEmpty()){
        s = remaining.remove();
        for (VirusState n : s.next()){
          pos = n.pos();
          if (!seen.containsKey(pos) && n.isValid()){
            remaining.add(n);
            seen.put(pos, n.t);
          }
        }
      }

      for (int i=0; i<N; i++){
        for (int j=0; j<M; j++){
          if (world[i][j] == 'A'){
            s = new VirusState(i, j, t+5, N, M, world);
            pos = s.pos();
            if (!seen.containsKey(pos) && s.isValid()){
              remaining.add(s);
              seen.put(pos, s.t);
            }
          }
        }
      }
    
        while (!remaining.isEmpty()) {
          s = remaining.remove();
          for (VirusState n : s.next()){
            pos = n.pos();
            if (!seen.containsKey(pos) && n.isValid()){
              remaining.add(n);
              seen.put(pos, n.t);
          }
        }
      }
    }

    

    SotState sotSrc = null;
    for (int i=0; i<N; i++){
      for (int j=0; j<M; j++){
        if (world[i][j] == 'S')
          sotSrc = new SotState(i, j, 0, N, M, world, seen, 'n', null);
      }
    }


    Set<SotState> seen2 = new HashSet<>();
    Queue<SotState> remaining2 = new ArrayDeque<>();
    remaining2.add(sotSrc);
    seen2.add(sotSrc);

    SotState r;
    while (!remaining2.isEmpty()) {
      
      r = remaining2.remove();
      if (r.isFinal()) return r;
      for (SotState n : r.next())
        if (!seen2.contains(n) && n.isValid()){
          remaining2.add(n);
          seen2.add(n);
        }
    }

    return null;
  }
}
