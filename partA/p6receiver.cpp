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
    a.sin_family = AF_INET; a.sin_port = htons(17000);
    a.sin_addr.s_addr = inet_addr("127.0.0.1");
    int s = socket(AF_INET, SOCK_STREAM, 0);
    if (connect(s, (struct sockaddr*)&a, sizeof a) < 0) { perror("connect"); return 1; }

    char f[30];
    for (int i = 1; recv(s, f, sizeof f, 0) > 0 && strcmp(f, "exit") != 0; i++) {
        cout << "Frame " << i << " data " << f << " received\n";
        send(s, "ACK", 4, 0);
    }
    close(s);
    return 0;
}
