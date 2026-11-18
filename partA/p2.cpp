#include <iostream>
#include <string>
using namespace std;
string P = "10001000000100001";            // CRC-CCITT: x^16 + x^12 + x^5 + 1

string crc(string s) {                     // modulo-2 division, returns 16-bit remainder
    for (int i = 0; i + 17 <= (int)s.size(); i++)
        if (s[i] == '1')
            for (int j = 0; j < 17; j++) s[i + j] = (s[i + j] == P[j]) ? '0' : '1';
    return s.substr(s.size() - 16);
}

int main() {
    string d, r, z(16, '0');
    cout << "Enter data: "; cin >> d;
    string c = crc(d + z);
    cout << "CRC: " << c << "\nTransmitted frame: " << d + c << "\n";
    cout << "\nEnter received frame: "; cin >> r;
    c = crc(r);
    cout << "Receiver CRC: " << c << "\n"
         << (c == z ? "No error in frame" : "Error detected in frame") << "\n";
    return 0;
}
