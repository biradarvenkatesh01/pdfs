#include <iostream>
using namespace std;
int p[10];

void path(int v) {                            // print path by following parents
    if (p[v] != -1) { path(p[v]); cout << " -> "; }
    cout << v;
}

int main() {
    int n, s, c[10][10], d[10];
    bool v[10] = {false};
    cout << "Enter no. of nodes: "; cin >> n;
    cout << "Enter cost matrix (99 = no edge):\n";
    for (int i = 0; i < n; i++) for (int j = 0; j < n; j++) cin >> c[i][j];
    cout << "Enter source: "; cin >> s;

    for (int i = 0; i < n; i++) d[i] = 99, p[i] = -1;
    d[s] = 0;
    for (int k = 0; k < n; k++) {
        int u = -1;                                   // pick nearest unvisited node
        for (int j = 0; j < n; j++) if (!v[j] && (u == -1 || d[j] < d[u])) u = j;
        v[u] = true;
        for (int j = 0; j < n; j++)                   // relax its neighbours
            if (!v[j] && d[u] + c[u][j] < d[j]) d[j] = d[u] + c[u][j], p[j] = u;
    }
    for (int i = 0; i < n; i++) if (i != s) {
        cout << "\nShortest path from " << s << " to " << i << ":\n";
        path(i);
        cout << "\nDistance = " << d[i] << "\n";
    }
    return 0;
}
