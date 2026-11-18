#include <iostream>
using namespace std;

int main() {
    int cap, rate, n, p[25], left = 0;
    cout << "Enter bucket size: "; cin >> cap;
    cout << "Enter output rate: "; cin >> rate;
    cout << "Enter no. of seconds: "; cin >> n;
    for (int i = 0; i < n; i++) { cout << "Packets at second " << i + 1 << ": "; cin >> p[i]; }

    cout << "\nSec\tRecv\tSent\tLeft\tDropped\n";
    for (int i = 0; i < n || left > 0; i++) {
        int in = (i < n) ? p[i] : 0;
        left += in;
        int drop = (left > cap) ? left - cap : 0;     left -= drop;   // overflow dropped
        int sent = (left < rate) ? left : rate;       left -= sent;   // leak at fixed rate
        cout << i + 1 << "\t" << in << "\t" << sent << "\t" << left << "\t" << drop << "\n";
    }
    return 0;
}
