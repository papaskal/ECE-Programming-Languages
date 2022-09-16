(*        use "C:/Users/Alexandros/Documents/Programming/PL1_2020/coronagraph/coronagraph_v2.sml";*)
(*coronograph "C:/Users/Alexandros/Documents/Programming/PL1_2020/coronagraph/coronagraph.in1";*)

local
    fun rev l =
        let
            fun aux [] acc = acc
                | aux (x::xs) acc = aux xs (x::acc)
        in 
            aux l []
        end;

    fun len l =
        let 
            fun aux [] acc = acc
            |aux (x::xs) acc = aux xs (1+acc)
        in
            aux l 0
        end;

    fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
            

    fun parse file = 
        let        
            val inStream = TextIO.openIn file
            val t = readInt inStream
        in 
            (t, inStream)
        end;

    fun parseGraph inStream = 
        let
            val N = readInt inStream
            val M = readInt inStream
            val grph = Array.array(N, [])
            fun aux 0 = (N, M, grph)
            |aux i = 
                (let
                    val v = readInt inStream
                    val u = readInt inStream
                in
                    (Array.update(grph, (v-1), ((u-1)::(Array.sub(grph, (v-1)))));
                    Array.update(grph, (u-1), ((v-1)::(Array.sub(grph, (u-1)))));
                    aux (i-1))
                end)
        in 
            aux M
        end;

    fun sumList l = 
        let 
            fun aux [] acc = acc
            | aux (x::xs) acc = aux xs (x + acc)
        in 
            aux l 0
        end;

    fun eraseElem [] _ = []
    | eraseElem l e =
        let 
            fun aux2 xs [] = xs 
            | aux2 xs (y::ys) = aux2 (y::xs) ys
            fun aux [] _ acc = acc  
            | aux (x::xs) e acc = 
                if  (x = e) then aux2 xs acc
                else aux xs e (x::acc)
        in
            aux l e []
        end;
    
    fun calcCir grph parent p = 
        let 
            fun aux curr acc =
                (
                    Array.update(grph, curr, (eraseElem (Array.sub(grph, curr)) (Array.sub(parent, curr))));
                    Array.update(grph, (Array.sub(parent, curr)), (eraseElem (Array.sub(grph, (Array.sub(parent, curr)))) curr));
                    if (curr = p) then (curr::acc) 
                    else aux (Array.sub(parent, curr)) (curr::acc)
                )
        in 
            aux (Array.sub(parent, p)) []
        end;        

    fun visit v visited = (Array.update(visited, v, true); ());

    fun visitList [] visited = ()
    | visitList (x::xs) visited = 
        (visit x visited; 
        visitList xs visited);


    fun dfs1 v grph parent visited = 
        let 
            fun aux [] = ~1
            | aux (x::xs) = 
                if (Array.sub(visited, x) = true) then 
                (if (Array.sub(parent, v)) = x then aux xs else (Array.update(parent, x, v); x))
                else
                    let
                        val _ = Array.update(parent, x, v)
                        val temp = (dfs1 x grph parent visited)
                    in  
                        if (temp = ~1) then aux xs else temp
                    end
        in 
            (visit v visited;
            aux (Array.sub(grph, v)))
        end;



    fun findCircle grph n = 
        let 
            val visited = Array.array(n, false)
            val parent = Array.array(n, ~1)
            val cirPoint = (dfs1 0 grph parent visited) 
        in 
            if (cirPoint = ~1) then []
            else calcCir grph parent cirPoint
        end;

    fun dfs2 v grph parent visited = 
        let 
            fun aux [] acc = acc
            | aux (x::xs) acc = 
                if (Array.sub(visited, x) = true) then 
                (if (Array.sub(parent, v)) = x then aux xs acc else ~1)
                else
                    let
                        val _ = Array.update(parent, x, v)
                        val temp = (dfs2 x grph parent visited)
                    in  
                        if (temp = ~1) then ~1 else aux xs (acc + temp)
                    end                
        in 
            (visit v visited;
            aux (Array.sub(grph, v)) 1 )
        end;


    fun dfs2List grph visited parent cir n =
        let 
            val _ = visitList cir visited
            fun aux [] trees = trees
            | aux (x::xs) trees =
                let
                    val temp = dfs2 x grph parent visited
                in 
                    if (temp = ~1) then []
                    else aux xs (temp::trees)
                end
            val res = aux cir []
        in
            if ((sumList res) = n) then res else []
        end;


    fun countTrees grph cir n =
        let 
            val visited = Array.array(n, false)
            val parent = Array.array(n, ~1)
        in 
            dfs2List grph visited parent cir n
        end;

    fun printCorona xs = 
        print("CORONA " ^ Int.toString (len xs) ^ "\n" ^ String.concatWith " " (map Int.toString xs) ^ "\n")



    fun findCorona grph n =
        let
            val cir = findCircle grph n
        in 
            if (cir = []) then print("NO CORONA\n")
            else(  
                let 
                    val trees = countTrees grph cir n
                in 
                    if (trees = []) then print("NO CORONA\n")
                    else printCorona (ListMergeSort.sort (fn (a, b) => a > b) trees)
                end
            )
        end;


    
    
    
    fun printList xs =                                                                  (*stackoverflow*)
        print("[" ^ String.concatWith "," (map Int.toString xs) ^ "]\n");

    fun printGraph grph n =
        let 
            fun aux i = if i=n then () else (printList (Array.sub(grph, i)); aux (i+1))
        in 
            aux 0
        end;

    fun doTheGraphs t stre = 
        let 
            fun aux 0 = ()
            | aux i =
                (let 
                    val inp = parseGraph stre
                    val n = #1 inp
                    val m = #2 inp
                    val grph = #3 inp
                in
                    (*(printGraph grph n;*)
                    (findCorona grph n;
                    aux (i-1))
                end)
        in
            aux t
        end;



in 

    fun coronograph file_name = 
        let
            val inp = parse file_name
            val t = #1 inp
            val stre = #2 inp
        in 
            doTheGraphs t stre
        end;

end;
