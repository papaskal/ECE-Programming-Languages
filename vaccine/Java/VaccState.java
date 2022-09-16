import java.util.*;

public class VaccState implements State{
    public String rna, comp;
    public int ind;
    public boolean compFlag;
    public char top, bot, move;
    public HashSet<Character> group;
    public State previous;
 
    public VaccState(String rna, String comp, int ind, boolean compFlag, char top, char bot, char move, HashSet<Character> group, State previous){
        this.rna = rna;
        this.comp = comp;
        this.ind = ind;
        this.compFlag = compFlag;
        this.top = top;
        this.bot = bot;
        this.move = move;
        this.group = group;
        this.previous = previous;
    }

    public VaccState(VaccState previous, char move){
        this.previous = previous;
        this.move = move;
        rna = previous.rna;
        comp = previous.comp;

        ind = previous.ind;
        compFlag = previous.compFlag;
        top = previous.top;
        bot = previous.bot;
        group = previous.group;

        if (move == 'c') {
            compFlag = !previous.compFlag;
        }
        else if (move == 'p') {
            if (previous.compFlag)
                top = rna.charAt(ind);
            else 
                top = comp.charAt(ind);
            ind = previous.ind + 1;
            if (!group.contains(top)){
                group = new HashSet<Character>() ;
                group.addAll(previous.group);
                group.add(top);
            }
        }
        else {
            char temp = top;
            top = bot;
            bot = temp;
        }
        
    }

    @Override
    public boolean isFinal() {
        return ind >= rna.length();
    }

    @Override
    public Collection<State> next(){
        Collection<State> states = new ArrayList<>();
        if (move == 'p')
            states.add(new VaccState(this, 'c'));
        
        char c;
        if (compFlag) {
            c = rna.charAt(ind);
        }
        else {
            c = comp.charAt(ind);
        }
        if ((c == top) || (!group.contains(c)))
            states.add(new VaccState(this, 'p'));

        if ((move == 'p') || move == 'c')
            states.add(new VaccState(this, 'r'));
        return states;
    }

    @Override
    public State getPrevious(){
        return previous;
    }

    @Override
    public String toString() {
      return String.valueOf(move);
    }

}