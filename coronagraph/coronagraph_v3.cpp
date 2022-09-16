using namespace std;

#include <iostream>
#include <vector>
#include <stack>
#include <unordered_set>
#include <fstream>
#include <algorithm>

void input(ifstream &myInput, vector<unordered_set<unsigned int>> &data);
 
void findCorona(vector<unordered_set<unsigned int>> &grph);

vector<unsigned int> findCircle(vector<unordered_set<unsigned int>> &grph);

bool countTrees(const vector<unordered_set<unsigned int>> &grph, const vector<unsigned int> &cir, vector<unsigned int> &trees);

int dfs1(stack<unsigned int> &dfsStack, const vector<unordered_set<unsigned int>> &grph, vector<unsigned int> &parent, vector<bool> &visited);

bool dfs2(stack<unsigned int> &dfsStack, const vector<unordered_set<unsigned int>> &grph, vector<unsigned int> &parent, vector<bool> &visited);

unsigned int sumVect(vector<unsigned int> vect);
 
/*******************************************/


int main(int argc, char **argv){

    if (argc!=2) {
        cerr << "ERROR" << endl;
        return -1;
    }

    vector<unordered_set<unsigned int>> grph;
    unsigned int T;
    
    ifstream myInput;
    myInput.open(argv[1]);
    myInput >> T;

    for (unsigned int i=0; i<T; i++){
        input(myInput, grph);
        findCorona(grph);
    }
    
    myInput.close();

    return 0;
}


/*******************************************/

void findCorona(vector<unordered_set<unsigned int>> &grph){
    vector<unsigned int> cir = findCircle(grph), trees;
    if (cir.empty() || !countTrees(grph, cir, trees)){
        cout << "NO CORONA\n";
        return;
    }

    cout << "CORONA " << cir.size() << "\n";
    for (unsigned int i=0; i<trees.size()-1; i++){
        cout << trees[i] << " ";
    }
    cout << trees[trees.size()-1] << "\n";

}

unsigned int sumVect(vector<unsigned int> vect){
    unsigned int sum = 0;
    for (unsigned int elem : vect)
        sum += elem;
    
    return sum;
}

vector<unsigned int> findCircle(vector<unordered_set<unsigned int>> &grph){
    vector<unsigned int> res;
    vector<bool> visited;
    vector<unsigned int> parent;
    stack<unsigned int> dfsStack;
    unsigned int M = grph.size();
    int cirPoint = -1;

    visited.resize(M);
    parent.resize(M);

    for (unsigned int i=0; i<M; i++){
        visited[i] = false;
        parent[i] = M;
    }
    
    dfsStack.push(0);
    while (!dfsStack.empty() && (cirPoint == -1)){
        cirPoint = dfs1(dfsStack, grph, parent, visited);
    }
    if (cirPoint == -1)
        return res;
    
    unsigned int p = cirPoint;

    do {
        grph[p].erase(parent[p]);
        grph[parent[p]].erase(p);
        p = parent[p];
        res.push_back(p);
    } while ((int)p != cirPoint);
   
    return res;
}

int dfs1(stack<unsigned int> &dfsStack, const vector<unordered_set<unsigned int>> &grph, vector<unsigned int> &parent, vector<bool> &visited){
    unsigned int v = dfsStack.top();
    dfsStack.pop();

    visited[v] = true;
    for (unsigned int elem : grph[v]){
        if (visited[elem]){
            if (parent[v] == elem)
                continue;
            else {
                parent[elem] = v;
                return elem;
            }
        }
        parent[elem] = v;
        dfsStack.push(elem);
    }
    return -1;
}

bool countTrees(const vector<unordered_set<unsigned int>> &grph, const vector<unsigned int> &cir, vector<unsigned int> &trees){
    vector<bool> visited;
    vector<unsigned int> parent;
    stack<unsigned int> dfsStack;
    int temp;

    visited.resize(grph.size());
    parent.resize(grph.size());
    
    

    for (unsigned int i=0; i<visited.size(); i++){
        parent[i] = grph.size();
        visited[i] = false;
    }

    for (unsigned int elem : cir){
        visited[elem] = true;
    }

    for (unsigned int elem : cir){
        temp = 0;
        dfsStack.push(elem);
        while (!dfsStack.empty()){
            if (!dfs2(dfsStack, grph, parent, visited))
                return false;
            temp++;
        }
        
        trees.push_back(temp);
    }

    for (bool elem : visited){
        if (!elem){
            return false;
        }
    }

    sort(trees.begin(),trees.end());

    return true;
}

bool dfs2(stack<unsigned int> &dfsStack, const vector<unordered_set<unsigned int>> &grph, vector<unsigned int> &parent, vector<bool> &visited){
    unsigned int v = dfsStack.top();
    dfsStack.pop();

    visited[v] = true;
    for (unsigned int elem : grph[v]){
        if (visited[elem]){
            if (parent[v] == elem)
                continue;
            else {
                return false;
            }
        }
        parent[elem] = v;
        dfsStack.push(elem);
    }

    return true;
}

void input(ifstream &myInput, vector<unordered_set<unsigned int>> &data){                        
    unsigned int n1, n2, N, M;

    myInput >> N;
    myInput >> M;
    
    data.clear();
    data.resize(N);
    for (unsigned int i=0; i<M; i++){
        myInput >> n1;
        myInput >> n2;
        data[n1-1].insert(n2-1);
        data[n2-1].insert(n1-1);
    }
}
