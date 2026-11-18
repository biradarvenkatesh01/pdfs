#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
using namespace std;

int main() {
    struct sockaddr_in a;
    memset(&a, 0, sizeof a);
    a.sin_family = AF_INET; a.sin_port = htons(8080);
    a.sin_addr.s_addr = inet_addr("127.0.0.1");
    int s = socket(AF_INET, SOCK_DGRAM, 0);

    char f[256], b[4096];
    cout << "Enter filename: "; cin >> f;
    sendto(s, f, strlen(f), 0, (struct sockaddr*)&a, sizeof a);

    int n = recvfrom(s, b, sizeof b, 0, NULL, NULL);
    cout << "\nFile contents:\n";
    cout.write(b, n);
    close(s);
    return 0;
}
