#include <iostream>
#include <cstdio>
#include <cstring>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
using namespace std;

int main() {
    struct sockaddr_in a;
    memset(&a, 0, sizeof a);
    a.sin_family = AF_INET; a.sin_port = htons(8000); a.sin_addr.s_addr = INADDR_ANY;
    int s = socket(AF_INET, SOCK_STREAM, 0);
    bind(s, (struct sockaddr*)&a, sizeof a); listen(s, 5);
    cout << "Server waiting for client...\n";

    int c = accept(s, NULL, NULL);
    char f[256] = {0}, b[1024];
    recv(c, f, 255, 0);
    cout << "Requested file: " << f << "\n";

    FILE *fp = fopen(f, "r");
    if (!fp) { send(c, "File not found\n", 15, 0); cout << "File not found\n"; }
    else {
        int n;
        while ((n = fread(b, 1, sizeof b, fp)) > 0) send(c, b, n, 0);
        fclose(fp); cout << "File sent\n";
    }
    close(c); close(s);
    return 0;
}
