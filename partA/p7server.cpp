#include <iostream>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
using namespace std;

int main() {
    char f[100] = {0}, b[3000];
    int n;
    mkfifo("fifo1", 0666); mkfifo("fifo2", 0666);
    cout << "SERVER ONLINE\nWaiting for request...\n";

    int r = open("fifo1", O_RDONLY); read(r, f, 99);   // filename comes in on fifo1
    int w = open("fifo2", O_WRONLY);                   // contents go out on fifo2
    int file = open(f, O_RDONLY);

    if (file < 0) { write(w, "File not found!\n", 16); cout << "File not found\n"; }
    else {
        while ((n = read(file, b, sizeof b)) > 0) write(w, b, n);
        close(file); cout << "Server: " << f << " found, transfer completed\n";
    }
    close(r); close(w);
    return 0;
}
