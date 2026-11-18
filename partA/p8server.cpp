#include <iostream>
#include <cstdio>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
using namespace std;

int main() {
    struct sockaddr_in a, c;
    socklen_t l = sizeof c;
    memset(&a, 0, sizeof a);
    a.sin_family = AF_INET; a.sin_port = htons(8080); a.sin_addr.s_addr = INADDR_ANY;
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    bind(s, (struct sockaddr*)&a, sizeof a);
    cout << "UDP server waiting..." << endl;

    char f[256], b[4096];
    while (true) {
        int n = recvfrom(s, f, 255, 0, (struct sockaddr*)&c, &l); f[n] = 0;
        cout << "Requested file: " << f << endl;

        FILE *fp = fopen(f, "r");
        if (!fp) { strcpy(b, "File not found\n"); n = strlen(b); }
        else     { n = fread(b, 1, sizeof b, fp); fclose(fp); }
        sendto(s, b, n, 0, (struct sockaddr*)&c, l);       // whole file in one datagram
        cout << (fp ? "File sent" : "File not found") << endl;
    }
    return 0;
}
