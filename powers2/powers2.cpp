using namespace std;

#include <iostream>
#include <vector>
#include <fstream>

void input(vector<vector<unsigned int>> &, const string &);

vector<unsigned int> convertToBin(unsigned int N);

void splitToPowers2(unsigned int N, unsigned int K);

unsigned int countAces(vector<unsigned int> &arr);

void doTheThing(vector<unsigned int> &arr, unsigned int &p, unsigned int &k);

void printRes(vector<unsigned int> &arr);

unsigned int findNextAce(vector<unsigned int> &arr, unsigned int p);

 
/*******************************************/


int main(int argc, char **argv){

    if (argc!=2) {
        cerr << "ERROR" << endl;
        return -1;
    }

    vector<vector<unsigned int>> data;
    
    input(data, argv[1]);             

    for (unsigned int i=0; i<data.size(); i++){
        splitToPowers2(data[i][0], data[i][1]);
    }
  
    return 0;
}


/*******************************************/

void splitToPowers2(unsigned int N, unsigned int K){
    vector<unsigned int> arr = convertToBin(N);
    unsigned int c = countAces(arr), p;

    if ((N < K) || (c > K)){
        cout << "[]\n";
        return;
    }

    if (N==1){
        printRes(arr);
        return;
    }

    K -= c;
    p = findNextAce(arr, 1);

    while (K > 0){
        doTheThing(arr, p, K);
    }

    printRes(arr);

}

vector<unsigned int> convertToBin(unsigned int N){
    vector<unsigned int> res;

    while (N != 0){
        res.push_back(N % 2);
        N /= 2;
    }

    return res;
}

unsigned int countAces(vector<unsigned int> &arr){
    unsigned int res = 0;
    for (unsigned int elem : arr){
        res += elem;
    }

    return res;
}

unsigned int findNextAce(vector<unsigned int> &arr, unsigned int p){
    
    for (unsigned int i=p; i<arr.size(); i++){
        if (arr[i] != 0)
            return i; 
    }

    return 0;
}

void doTheThing(vector<unsigned int> &arr, unsigned int &p, unsigned int &K){
    unsigned int t = 1 << p;
    if (t - 1 <= K){
        K -= t - 1;
        arr[p]--;
        arr[0] += t;
        p = findNextAce(arr, p);
    }
    else{
        K--;
        arr[p--]--;
        arr[p] += 2;
    }
}

void printRes(vector<unsigned int> &arr){
    while (arr[arr.size()-1] == 0)
        arr.pop_back();

    cout << "[";
    for (unsigned int i=0; i<arr.size()-1; i++){
        cout << arr[i] << ",";
    }
    cout << arr[arr.size()-1] << "]\n";
}

void input(vector<vector<unsigned int>> &data, const string &file_name){                        
    unsigned int T;
    
    ifstream myInput;
    myInput.open(file_name);
    myInput >> T;
    
    data.resize(T);
    for (unsigned int i=0; i<T; i++){
        data[i].resize(2);
        myInput >> data[i][0];
        myInput >> data[i][1];
    }

    myInput.close();
}
