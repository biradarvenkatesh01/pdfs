#include <iostream>
#include <cstring>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
using namespace std;

int main() {
    char f[100], b[3000];
    int n;
    mkfifo("fifo1", 0666); mkfifo("fifo2", 0666);
    cout << "Enter filename: "; cin >> f;

    int w = open("fifo1", O_WRONLY); write(w, f, strlen(f)); close(w);

    int r = open("fifo2", O_RDONLY);
    cout << "\nReceived file contents:\n";
    while ((n = read(r, b, sizeof b)) > 0) cout.write(b, n);
    close(r);
    return 0;
}
