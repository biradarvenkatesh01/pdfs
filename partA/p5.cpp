#include <iostream>
#include <string>
using namespace std;
int h[12];                                  // positions 1..11 (1,2,4,8 = parity)

void show(string m) {
    cout << m;
    for (int i = 1; i <= 11; i++) cout << h[i] << " ";
    cout << "\n";
}

int main() {
    string d; cout << "Enter 7 data bits: "; cin >> d;
    int pos[] = {3, 5, 6, 7, 9, 10, 11};
    for (int i = 0; i < 7; i++) h[pos[i]] = d[i] - '0';

    for (int p = 1; p <= 8; p *= 2)          // even parity over positions having bit p set
        for (int i = 1; i <= 11; i++) if ((i & p) && i != p) h[p] ^= h[i];
    show("Transmitted codeword:\n");

    int e; cout << "Enter error position (0 = no error): "; cin >> e;
    if (e) { h[e] ^= 1; show("Erroneous codeword:\n"); }

    int s = 0;                              // syndrome = XOR of positions holding 1
    for (int i = 1; i <= 11; i++) if (h[i]) s ^= i;
    cout << "Error position: " << s << "\n";
    if (s) h[s] ^= 1;
    show("Corrected codeword:\n");
    return 0;
}
