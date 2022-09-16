
(*    use  "C:/Users/Alexandros/Documents/Programming/PL1_2020/stayhome/stayhome.sml";*)
(*stayhome "C:/Users/Alexandros/Documents/Programming/PL1_2020/stayhome/stayhome.in1";*)

local
    fun len l =
        let 
            fun length_h acc [] = acc
            | length_h acc (x::xs) = length_h (acc+1) xs
        in
            length_h 0 l 
        end;


    fun rev l =
        let
            fun rev_h acc [] = acc
            | rev_h acc (x::xs) = rev_h (x::acc) xs
        in
            rev_h [] l 
        end;


    fun printList [] = ()
        | printList (x::xs) = (print x; printList xs);


    fun upd arr m (i, j) c =
        Array.update(arr, m*i+j, c);


    fun see arr m (i, j) =
        Array.sub(arr, m*i+j);


    fun readChars_first m l input =
        if TextIO.endOfStream input then (m, l)
        else 
            let
                val c = Option.valOf (TextIO.input1 input)
            in
                (if c = #"\n" then (m, l)
                else (readChars_first (m+1) (c::l) input))
            end;


    fun readChars_rest l input =
        if TextIO.endOfStream input then l
        else 
            let
                val c = Option.valOf (TextIO.input1 input)
            in
                (if c = #"\n" then readChars_rest l input
                else (readChars_rest (c::l) input))
            end;


    fun parsing_first file_name = 
        let 
            val inStream = TextIO.openIn file_name
            
        in
            readChars_first 0 [] inStream
        end;


    fun parse file_name = 
        let 
            val inStream = TextIO.openIn file_name
            val r = readChars_first 0 [] inStream
            val m = #1 r
            val l = #2 r
        in
            (m, readChars_rest l inStream)
        end;


    fun bat arr m =
        let
            fun aux p = if (see arr m ((p div m), (p mod m))) = #"W" then ((p div m), (p mod m))
                        else aux (p+1)
        in 
            aux 0
        end;

    fun sot arr m =
        let
            fun aux p = if (see arr m ((p div m), (p mod m))) = #"S" then ((p div m), (p mod m))
                        else aux (p+1)
        in 
            aux 0
        end;

    fun aer arr n m time t=
        let 
            val size = n*m
            fun aux p acc = 
                if p = size then acc
                else if (see arr m ((p div m), (p mod m))) = #"A" then (upd time m ((p div m), (p mod m)) t; aux (p+1) (((p div m), (p mod m))::acc))
                else aux (p+1) acc
        in 
            aux 0 []
        end;


    fun wayHome m prev home =
        let 
            fun aux "S" _ acc = acc 
                | aux "D" (i, j) acc = aux (see prev m (i-1, j)) (i-1, j) (("D")::acc)
                | aux "L" (i, j) acc = aux (see prev m (i, j+1)) (i, j+1) (("L")::acc)
                | aux "R" (i, j) acc = aux (see prev m (i, j-1)) (i, j-1) (("R")::acc)
                | aux "U" (i, j) acc = aux (see prev m (i+1, j)) (i+1, j) (("U")::acc)
                | aux _ _ _ = ["Error!\n"]
        in 
            aux (see prev m home) home []
        end;


    fun epidemic arr n m time source flag =
        let
            fun infect (i,j) t acc = 
                if i<n andalso i>=0 andalso j<m andalso j>=0 then 
                    (if ((see arr m (i,j))= #"." orelse (see arr m (i,j))= #"S") then 
                        (upd arr m (i,j) #"W"; upd time m (i,j) t; ((i,j)::acc))
                    else if (see arr m (i,j))= #"A" then  
                        (upd arr m (i,j) #"W"; upd time m (i,j) t; if (Array.sub(flag, 0) = ~1) then Array.update(flag, 0, ~2) else (); ((i,j)::acc))
                    else if (see arr m (i,j))= #"T" then
                        (upd time m (i,j) t; Array.update(flag, 0, ~3); [])
                    else 
                        acc)
                else 
                    acc
            fun aux _ [] [] = []
             | aux t [] acc = 
                if (Array.sub(flag, 0) = ~1) then aux (t+2) acc []
                else if (Array.sub(flag, 0) = ~2) then acc
                else []
             | aux t ((i,j)::nfected) acc = 
                let 
                    val a = infect (i+1,j) t acc
                    val b = infect (i-1,j) t a
                    val c = infect (i,j+1) t b
                    val d = infect (i,j-1) t c
                in 
                    aux t nfected d
                end
        in 
            (upd time m source 0;
            aux 2 [source] [] )
        end;


    fun pandemic _ _ _ _ [] _ = () 
     | pandemic arr n m time infected flag =
        let
            val T = see time m (hd infected)
            fun infect (i,j) t acc = 
                if i<n andalso i>=0 andalso j<m andalso j>=0 then 
                    (if ((see arr m (i,j))= #"." orelse (see arr m (i,j))= #"S") orelse (see arr m (i,j))= #"A" then 
                        (upd arr m (i,j) (#"W"); upd time m (i,j) t; ((i,j)::acc))
                    else if (see arr m (i,j))= #"T" then
                        (upd time m (i,j) t; Array.update(flag, 0, ~3); ((i,j)::acc))
                    else 
                        acc)
                else 
                    acc
            
            fun spread _ [] acc = acc
             | spread t ((i,j)::nfected) acc = 
                let 
                    val a = infect (i+1,j) t acc
                    val b = infect (i-1,j) t a
                    val c = infect (i,j+1) t b
                    val d = infect (i,j-1) t c
                in 
                    spread t nfected d
                end
            
            fun aux t evenSrc oddSrc = 
                let 
                    val a = spread t evenSrc []
                    val b = spread (t+1) oddSrc []
                in 
                    if (a = [] andalso b = []) orelse Array.sub(flag, 0) = ~3 then ()
                    else aux (t+2) a b
                end
            
            val fir = spread (T+2) infected []
            val sec = spread (T+4) fir []
            val thi = aer arr n m time (T+5)
        in 
            aux (T+6) sec thi
        end;


    fun runSotRun arr n m time prev source flag = 
        let 
            fun move t (i,j) dir acc = 
                if i<n andalso i>=0 andalso j<m andalso j>=0 then 
                    if ((see arr m (i,j)) = #"W" orelse (see arr m (i,j)) = #"." orelse (see arr m (i,j)) = #"A") andalso (see time m (i,j)) > t then
                        (upd arr m (i,j) #"S"; upd prev m (i,j) dir;  ((i,j)::acc))
                    else if (see arr m (i,j)) = #"T" andalso (see time m (i,j)) > t then 
                        (upd arr m (i,j) #"H"; Array.update(flag, 0, (i*m+j)); upd prev m (i,j) dir;  []) 
                    else acc
                else acc 

            fun aux _ [] [] = () 
             | aux t [] acc =
                if Array.sub(flag, 0) < 0 then aux (t+1) (rev acc) []
                else ()
             | aux t ((i,j)::ot) acc = 
                let 
                    val a = move t (i+1,j) "D" acc
                    val b = move t (i,j-1) "L" a
                    val c = move t (i,j+1) "R" b
                    val d = move t (i-1,j) "U" c
                in 
                    aux t ot d
                end 
        in 
            (upd arr m source #"S";
            aux 1 [source] [])
        end;

in 


    fun stayhome file_name =
        let 
            
            val inp = parse file_name
            val world = #2 inp
            val m = #1 inp
            val n = (length world) div m
            val arr = Array.fromList (rev world)
            val flag = Array.array(1, ~1)
            val prev = Array.array((n*m), "S")
            val time = Array.array((n*m), (n*m))
            val virus = bat arr m 
            val startingPos = sot arr m

            val a = epidemic arr n m time virus flag
            val _ = pandemic arr n m time a flag
            val _ = runSotRun arr n m time prev startingPos flag
            val f = Array.sub(flag, 0)
        in
            if f < 0 then print ("IMPOSSIBLE\n")
            else 
                let 
                    val l = wayHome m prev (f div m, f mod m)
                in 
                    (print (Int.toString (len l) ^ "\n");
                    printList l;
                    print("\n"))
                end
        end
end;

