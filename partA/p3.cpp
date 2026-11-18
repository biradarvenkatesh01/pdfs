#include <iostream>
using namespace std;

int main() {
    int n, d[10][10], nx[10][10];
    cout << "Enter no. of nodes: "; cin >> n;
    cout << "Enter cost matrix (99 = no link):\n";
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) cin >> d[i][j], nx[i][j] = j;

    for (int k = 0; k < n; k++)                       // update tables via each router k
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                if (d[i][k] + d[k][j] < d[i][j])
                    d[i][j] = d[i][k] + d[k][j], nx[i][j] = nx[i][k];

    for (int i = 0; i < n; i++) {
        cout << "\nRouting table for router " << char('A' + i) << "\nDest\tNextHop\tDist\n";
        for (int j = 0; j < n; j++)
            cout << char('A' + j) << "\t" << char('A' + nx[i][j]) << "\t" << d[i][j] << "\n";
    }
    return 0;
}
