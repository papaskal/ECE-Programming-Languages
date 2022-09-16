rna = ""
comp = ""
length = 0
states = {}
q = 0

def vaccine(f):
    Q = int(f.readline())
    for i in range(0,Q):
        s = f.readline()
        s = s[len(s)-2::-1]
        #print(s)
        print(solve(s))

def solve(s):
    global rna, comp, length, states, q
    rna = s
    comp = complement(s)
    length = len(s)
    c = rna[0]
    g = {}
    g['A'] = False
    g['C'] = False
    g['G'] = False
    g['U'] = False
    g[c] = True
    p = i = q = 0
    states[i] = (p+1, True, g, c, c, 'p', -1)

    while True:
        state = states[i]
        addC(state, i)
        if addP(state, i):
            break
        addR(state, i)
        i += 1
    
    return moves()

def addC(state, i):
    global states, q
    prevMove = state[5]
    if prevMove == 'p':
        q += 1
        states[q] = (state[0], not state[1], state[2], state[3], state[4], 'c', i)

def addP(state, i):
    global states, q
    p = state[0]
    compFlag = state[1]
    if compFlag:
        c = rna[p]
    else :
        c = comp[p]
    if (c == state[3]) or (not state[2][c]):
        q += 1
        states[q] = (p+1, compFlag, newGroup(state[2], c), c, state[4], 'p', i)
        if p+1 >= length:
            return True
    return False

def addR(state, i):
    global states, q
    prevMove = state[5]
    if prevMove == 'p' or prevMove == 'c':
        q += 1
        states[q] = (state[0], state[1], state[2], state[4], state[3], 'r', i)

def newGroup(oldG, c):
    g = {}
    g['A'] = oldG['A']
    g['C'] = oldG['C']
    g['G'] = oldG['G']
    g['U'] = oldG['U']
    g[c] = True
    
    return g


def complement(s):
    res = []
    for c in s:
        if c == 'A' :
            res.append('U')
        elif c == 'U':
            res.append('A')
        elif c == 'C':
            res.append('G')
        elif c == 'G':
            res.append('C')
    #res.reverse()
    return("".join(res))


def moves():
    global states, q
    res = []
    while q != -1:
        res.append(states[q][5])
        q = states[q][6]
    res.reverse()
    return("".join(res))

def verify(mov):
    p = 0
    res = []
    flag = True
    for elem in mov:
        if elem == 'c':
            flag = not flag
        elif elem == 'r':
            res.reverse()
        elif elem == 'p':
            if flag:
                res.append(rna[p])
            else:
                res.append(comp[p])
            p += 1
        else:
            print("Error", elem)
    return ("".join(res))
    

if __name__ == "__main__":
    import sys
       
    if len(sys.argv) > 1:
        with open(sys.argv[1], "rt") as f:
            vaccine(f)
    else:
        vaccine(sys.stdin)
    
    #s = "GAUUCCGCCUGCACGCC"
    #mov = solve(s[::-1])
    #print(rna)
    #print(comp)
    #print(mov)
    #print(verify(mov))