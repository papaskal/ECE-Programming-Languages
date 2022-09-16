#python ./stayhome.py ./stayhome.in1

N = M = 0
world = {}
prev = {}
time = {}
sot = []
virusEven = []
virusOdd = []
aer = []
t = 0
flag = -1


def readFile(f):
    global N, M, world, prev, sot, virusEven, time
    i = j = 0
    while True:    
        ch = f.read(1)
        if not ch:
            N = i
            break
        if ch != '\n':
            world[i, j] = ch
            if ch == 'S':
                sot.append((i,j))
                prev[i,j] = 'S'
            elif ch == 'W':
                virusEven.append((i,j))
                time[i,j] = 0
            j += 1
        else :
            M = j
            j = 0
            i += 1


def stayhome(f):
    readFile(f)
    print(saveSot())
    
def saveSot():
    global N, M, world, prev, virusEven, virusOdd, flag, sot, t
    t = 0
    
    while virusEven != [] and flag == -1:
        t += 2
        virusEven = epidemic(virusEven)

    if flag == -2:
        t += 2
        virusEven = epidemic(virusEven)
        t += 2
        virusEven = epidemic(virusEven)
        
        t += 1
        for key, val in world.items():
            if val == 'A':
                virusOdd.append(key)
                world[key] = 'W'
                time[key] = t

        while ((virusEven != []) or (virusOdd != [])) and flag == -2:
            
            t += 1
            virusEven = epidemic(virusEven)
            t += 1
            virusOdd = epidemic(virusOdd)



    world[sot[0]] = 'S'

    t = 0
    while flag < 0 and sot != []:
        t += 1
        runSotRun()

    if flag < 0:
        return ("IMPOSSIBLE")

    s = wayHome()
    return str(len(s)) + "\n" + s
        

def epidemic(vir):
    global N, M

    acc = []
    while vir != []:
        x, y = vir.pop()
        if x+1 < N:
            infect(x+1, y, acc)
        if x-1 >= 0:
            infect(x-1, y, acc)
        if y+1 < M:
            infect(x, y+1, acc)
        if y-1 >= 0:
            infect(x, y-1, acc)
    return acc


def infect(x, y, acc):
    global t, world, time, flag

    temp = world[x,y]
    if temp != 'W' and temp != 'X':
        if temp == 'A' and flag == -1:
            flag = -2
        world[x,y] = 'W'
        time[x,y] = t
        acc.append((x,y))
        if temp == 'T':
            flag = -3
            world[x,y] = 'T'


def runSotRun():
    global N, M, sot
    acc = []
    sot.reverse()

    while sot != []:
        x, y = sot.pop()
        if x+1 < N:
            move(x+1, y, 'D', acc)
        if y-1 >= 0:
            move(x, y-1, 'L', acc)
        if y+1 <M:
            move(x, y+1, 'R', acc)
        if x-1 >= 0:
            move(x-1, y, 'U', acc)

    sot = acc


def move(x, y, dir, acc):
    global t, M, world, prev, time, flag

    temp = world[x,y]
    if temp == 'T':
        world[x,y] = 'H'
        prev[x,y] = dir
        flag = x*M + y

    elif (temp == 'W' and t < time[x,y]) or temp == '.' or temp == 'A':
        world[x,y] = 'S'
        acc.append((x,y))
        prev[x,y] = dir


def wayHome():
    global prev, flag

    rev = []
    x, y = flag // M, flag % M
    c = prev[x,y]

    while c != 'S':
        if c == 'D':
            x -= 1
        elif c == 'L':
            y += 1
        elif c == 'R':
            y -= 1
        else:
            x += 1
        rev.append(c)
        c = prev[x,y]
    
    rev.reverse()
    return "".join(rev)

def printWorld():
    global N, M, world

    for i in range(0,N):
        for j in range(0,M):
            print(world[i,j], end="")
        print('')
    print()


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        with open(sys.argv[1], "rt") as f:
            stayhome(f)
    else:
        stayhome(sys.stdin)
