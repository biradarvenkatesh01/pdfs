#include <iostream>
#include <cstdio>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
using namespace std;

int main() {
    struct sockaddr_in a;
    memset(&a, 0, sizeof a);
    a.sin_family = AF_INET; a.sin_port = htons(8000);
    a.sin_addr.s_addr = inet_addr("127.0.0.1");
    int s = socket(AF_INET, SOCK_STREAM, 0);
    if (connect(s, (struct sockaddr*)&a, sizeof a) < 0) { perror("connect"); return 1; }

    char f[256], b[1024]; int n;
    cout << "Enter filename: "; cin >> f;
    send(s, f, strlen(f), 0);

    cout << "\nFile contents:\n";
    while ((n = recv(s, b, sizeof b, 0)) > 0) cout.write(b, n);
    close(s);
    return 0;
}
