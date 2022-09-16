(*    use "C:/Users/Alexandros/Documents/Programming/PL1_2020/powers2/powers2_v2.sml";*)
(*powers2 "C:/Users/Alexandros/Documents/Programming/PL1_2020/powers2/powers2.in1";*)

local 
    fun rev l =
        let
            fun aux [] acc = acc
                | aux (x::xs) acc = aux xs (x::acc)
        in 
            aux l []
        end;

    fun parse file =
        let
            fun readInt input = 
                Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
            
            val inStream = TextIO.openIn file

            val t = readInt inStream
            val _ = TextIO.inputLine inStream          

            fun readPairs 0 acc = rev acc
            | readPairs i acc = 
                let
                    val n = readInt inStream
                    val k = readInt inStream
                in 
                    readPairs (i-1) (k::n::acc)
                end
        in
            readPairs t []
        end;


    fun pow2 a =
        let
          fun aux 0 acc = acc
            |aux b acc = aux (b - 1) (2 * acc)
        in
          aux a 1
        end;

    fun convToUnits arr p =
        let
            val tmp1 = Array.sub(arr, 0) + (pow2 p);
            val tmp2 = Array.sub(arr, p) - 1;
        in
            (Array.update(arr, 0, tmp1);
            Array.update(arr, p, tmp2);
            arr)
        end;

    fun splitInTwo arr p =
        let
            val tmp1 = Array.sub(arr, p) -1;
            val tmp2 = Array.sub(arr, p-1) + 2;
        in
            (Array.update(arr, p, tmp1);
            Array.update(arr, p-1, tmp2);
            arr)
        end;

    fun convertToBin n =
        let
            fun aux 0 acc = rev acc
                | aux a acc = aux (a div 2) ((a mod 2)::acc)
        in 
            aux n []
        end; 

    
    fun arrayToList arr =                                                               (*stackoverflow*)
        Array.foldr (op ::) [] arr;

    fun printList xs =                                                                  (*stackoverflow*)
        print("[" ^ String.concatWith "," (map Int.toString xs) ^ "]\n");

    fun popLeadingZeros [] = []
    | popLeadingZeros (x::xs) =
        if (x=0) then popLeadingZeros xs else (x::xs);

    fun popEndZeros l =
        rev (popLeadingZeros (rev l));

    fun findNextAce arr p =
        if Array.sub(arr, p) > 0 then p else findNextAce arr (p+1);

    fun countAces myList =
        let
          fun aux [] acc = acc
            | aux (x::xs) acc = aux xs (x+acc)
        in
          aux myList 0
        end;

    fun doTheThing arr _ 0 = arr
    | doTheThing arr p k = 
        let
            val t = pow2 p;
        in
            if (t-1 <= k) then doTheThing (convToUnits arr p) (findNextAce arr p) (k - (t-1))
            else doTheThing (splitInTwo arr p) (p-1) (k-1)
        end;

    fun splitToPowers2 n k =
        let
            val bina = convertToBin n
            val arr = Array.fromList bina
            val c = countAces bina
        in
            if ((n < k) orelse (c > k)) then print ("[]\n")
            else (if (n=1) then printList bina 
            else (
                let
                    val p = findNextAce arr 1
                in 
                    printList (popEndZeros (arrayToList (doTheThing arr p (k-c))))
                end
            ))
        end;

    fun doThePairs [] = ()
    |doThePairs (_::[]) = ()
    |doThePairs (n::k::xs) = 
        (splitToPowers2 n k;
        doThePairs xs)

in 

    fun powers2 file_name = 
        let
            val inp = parse file_name
        in 
            doThePairs inp
        end;

end;
