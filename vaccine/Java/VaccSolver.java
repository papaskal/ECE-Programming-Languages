import java.util.*;

/* A class that implements a solver that explores the search space
 * using breadth-first search (BFS).  This leads to a solution that
 * is optimal in the number of moves from the initial to the final
 * state.
 */


public class VaccSolver implements Solver {
  @Override
  public State solve (State initial) {
    Queue<State> remaining = new ArrayDeque<>();
    remaining.add(initial);
    State s;
    while (true) {
      s = remaining.remove();
      if (s.isFinal()) return s;
      for (State n : s.next())
        remaining.add(n);
    }
    //return null;
  }
}