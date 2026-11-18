#include <iostream>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
using namespace std;

int main() {
    struct sockaddr_in a;
    memset(&a, 0, sizeof a);
    a.sin_family = AF_INET; a.sin_port = htons(17000); a.sin_addr.s_addr = INADDR_ANY;
    int s = socket(AF_INET, SOCK_STREAM, 0);
    bind(s, (struct sockaddr*)&a, sizeof a); listen(s, 5);
    cout << "Waiting for receiver...\n";
    int c = accept(s, NULL, NULL);

    char f[30], ack[10];
    for (int i = 1; ; i++) {
        cout << "Enter Data Frame " << i << " (exit to end): "; cin >> f;
        send(c, f, strlen(f) + 1, 0);
        if (strcmp(f, "exit") == 0) break;
        recv(c, ack, sizeof ack, 0);
        cout << "Acknowledgment: " << ack << "\n";
    }
    close(c); close(s);
    return 0;
}
