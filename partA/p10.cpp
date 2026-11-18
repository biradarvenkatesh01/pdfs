#include <iostream>
#include <netdb.h>
#include <arpa/inet.h>
using namespace std;

int main() {
    char h[100];
    cout << "Enter the domain name: "; cin >> h;
    struct hostent *he = gethostbyname(h);
    if (!he) { cout << "DNS lookup failed\n"; return 1; }
    cout << "\nHost Name: " << he->h_name
         << "\nIP Address: " << inet_ntoa(*(struct in_addr*)he->h_addr_list[0]) << "\n";
    return 0;
}
