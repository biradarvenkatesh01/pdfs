#!/bin/bash
# CN Lab program menu: list programs, show code, or save files in the current folder.
# Usage: bash cnlab.sh

C='\033[1;36m'; G='\033[1;32m'; Y='\033[1;33m'; D='\033[0;90m'; N='\033[0m'

f_p1_cpp() {
cat <<'CNEOF'
#include <iostream>
using namespace std;
int p[10];

void path(int v) {                            // print path by following parents
    if (p[v] != -1) { path(p[v]); cout << " -> "; }
    cout << v;
}

int main() {
    int n, s, c[10][10], d[10];
    bool v[10] = {false};
    cout << "Enter no. of nodes: "; cin >> n;
    cout << "Enter cost matrix (99 = no edge):\n";
    for (int i = 0; i < n; i++) for (int j = 0; j < n; j++) cin >> c[i][j];
    cout << "Enter source: "; cin >> s;

    for (int i = 0; i < n; i++) d[i] = 99, p[i] = -1;
    d[s] = 0;
    for (int k = 0; k < n; k++) {
        int u = -1;                                   // pick nearest unvisited node
        for (int j = 0; j < n; j++) if (!v[j] && (u == -1 || d[j] < d[u])) u = j;
        v[u] = true;
        for (int j = 0; j < n; j++)                   // relax its neighbours
            if (!v[j] && d[u] + c[u][j] < d[j]) d[j] = d[u] + c[u][j], p[j] = u;
    }
    for (int i = 0; i < n; i++) if (i != s) {
        cout << "\nShortest path from " << s << " to " << i << ":\n";
        path(i);
        cout << "\nDistance = " << d[i] << "\n";
    }
    return 0;
}
CNEOF
}

f_p2_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p3_cpp() {
cat <<'CNEOF'
#include <iostream>
using namespace std;

int main() {
    int n, d[10][10], nx[10][10];
    cout << "Enter no. of nodes: "; cin >> n;
    cout << "Enter cost matrix (99 = no link):\n";
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) cin >> d[i][j], nx[i][j] = j;

    for (int k = 0; k < n; k++)                       // update tables via each router k
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                if (d[i][k] + d[k][j] < d[i][j])
                    d[i][j] = d[i][k] + d[k][j], nx[i][j] = nx[i][k];

    for (int i = 0; i < n; i++) {
        cout << "\nRouting table for router " << char('A' + i) << "\nDest\tNextHop\tDist\n";
        for (int j = 0; j < n; j++)
            cout << char('A' + j) << "\t" << char('A' + nx[i][j]) << "\t" << d[i][j] << "\n";
    }
    return 0;
}
CNEOF
}

f_p4server_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p4client_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p5_cpp() {
cat <<'CNEOF'
#include <iostream>
#include <string>
using namespace std;
int h[12];                                  // positions 1..11 (1,2,4,8 = parity)

void show(string m) {
    cout << m;
    for (int i = 1; i <= 11; i++) cout << h[i] << " ";
    cout << "\n";
}

int main() {
    string d; cout << "Enter 7 data bits: "; cin >> d;
    int pos[] = {3, 5, 6, 7, 9, 10, 11};
    for (int i = 0; i < 7; i++) h[pos[i]] = d[i] - '0';

    for (int p = 1; p <= 8; p *= 2)          // even parity over positions having bit p set
        for (int i = 1; i <= 11; i++) if ((i & p) && i != p) h[p] ^= h[i];
    show("Transmitted codeword:\n");

    int e; cout << "Enter error position (0 = no error): "; cin >> e;
    if (e) { h[e] ^= 1; show("Erroneous codeword:\n"); }

    int s = 0;                              // syndrome = XOR of positions holding 1
    for (int i = 1; i <= 11; i++) if (h[i]) s ^= i;
    cout << "Error position: " << s << "\n";
    if (s) h[s] ^= 1;
    show("Corrected codeword:\n");
    return 0;
}
CNEOF
}

f_p6sender_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p6receiver_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p7server_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p7client_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p8server_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p8client_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_p9_cpp() {
cat <<'CNEOF'
#include <iostream>
using namespace std;

int main() {
    int cap, rate, n, p[25], left = 0;
    cout << "Enter bucket size: "; cin >> cap;
    cout << "Enter output rate: "; cin >> rate;
    cout << "Enter no. of seconds: "; cin >> n;
    for (int i = 0; i < n; i++) { cout << "Packets at second " << i + 1 << ": "; cin >> p[i]; }

    cout << "\nSec\tRecv\tSent\tLeft\tDropped\n";
    for (int i = 0; i < n || left > 0; i++) {
        int in = (i < n) ? p[i] : 0;
        left += in;
        int drop = (left > cap) ? left - cap : 0;     left -= drop;   // overflow dropped
        int sent = (left < rate) ? left : rate;       left -= sent;   // leak at fixed rate
        cout << i + 1 << "\t" << in << "\t" << sent << "\t" << left << "\t" << drop << "\n";
    }
    return 0;
}
CNEOF
}

f_p10_cpp() {
cat <<'CNEOF'
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
CNEOF
}

f_lab1_tcl() {
cat <<'CNEOF'
set ns [new Simulator]
set tf [open lab1.tr w]
$ns trace-all $tf
set nf [open lab1.nam w]
$ns namtrace-all $nf

# create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# packet colours and node labels (for NAM)
$ns color 1 "red"
$ns color 2 "blue"
$n0 label "Source/udp0"
$n1 label "Source/udp1"
$n2 label "Router"
$n3 label "Destination/Null"

# links: vary the bandwidth (n2-n3) and see the drops
$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 1Mb 300ms DropTail

# queue size between the nodes
$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 5

# UDP agent on n0 and n1, Null agent on n3
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

# udp0 packets red, udp1 packets blue
$udp0 set class_ 1
$udp1 set class_ 2

# connect the agents
$ns connect $udp0 $null3
$ns connect $udp1 $null3

# packet size and interval (data rate) of cbr1
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005

proc finish { } {
    global ns nf tf
    $ns flush-trace
    exec nam lab1.nam &
    close $tf
    close $nf
    exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 10.0 "finish"
$ns run
CNEOF
}

f_lab1_awk() {
cat <<'CNEOF'
BEGIN {
    count = 0
}
{
    if ($1 == "d")
        count++
}
END {
    printf("The Total no of Packets Dropped due to Congestion : %d\n", count)
}
CNEOF
}

f_lab2_tcl() {
cat <<'CNEOF'
set ns [new Simulator]
set tf [open lab2.tr w]
$ns trace-all $tf
set nf [open lab2.nam w]
$ns namtrace-all $nf

# create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# packet colours and node labels
$ns color 1 "red"
$ns color 2 "blue"
$n0 label "source/TCP"
$n1 label "source/UDP"
$n2 label "Router"
$n3 label "destination"

# links n0-n2, n1-n2, n2-n3
$ns duplex-link $n0 $n2 100Mb 1ms DropTail
$ns duplex-link $n1 $n2 100Mb 1ms DropTail
$ns duplex-link $n2 $n3 100Mb 1ms DropTail

# link colours and labels
$ns duplex-link-op $n0 $n2 color "green"
$ns duplex-link-op $n0 $n2 label "from 0-2"
$ns duplex-link-op $n1 $n2 color "green"
$ns duplex-link-op $n1 $n2 label "from 1-2"
$ns duplex-link-op $n2 $n3 color "green"
$ns duplex-link-op $n2 $n3 label "from 2-3"

# TCP + FTP from n0 to n3
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3

# UDP + CBR from n1 to n3
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

# packet size and interval
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.001
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.001

# TCP red, UDP blue
$tcp0 set class_ 1
$udp1 set class_ 2

# connect the agents
$ns connect $tcp0 $sink3
$ns connect $udp1 $null3

proc finish { } {
    global ns nf tf
    $ns flush-trace
    exec nam lab2.nam &
    close $nf
    close $tf
    exit 0
}

$ns at 0.1 "$cbr1 start"
$ns at 0.2 "$ftp0 start"
$ns at 5.0 "finish"
$ns run
CNEOF
}

f_lab2_awk() {
cat <<'CNEOF'
BEGIN {
    tcp = 0
    udp = 0
}
{
    if ($1 == "r" && $3 == "2" && $4 == "3" && $5 == "tcp")
        tcp++
    if ($1 == "r" && $3 == "2" && $4 == "3" && $5 == "cbr")
        udp++
}
END {
    printf("Total number of packets sent by TCP : %d\n", tcp)
    printf("Total number of packets sent by UDP : %d\n", udp)
}
CNEOF
}

f_lab3_tcl() {
cat <<'CNEOF'
set ns [new Simulator]
set tf [open lab3.tr w]
$ns trace-all $tf
set nf [open lab3.nam w]
$ns namtrace-all $nf

# create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 label "Ping0"
$n4 label "Ping4"
$n1 label "Ping1"
$n5 label "Ping5"
$ns color 1 "blue"
$ns color 2 "orange"

# links
$ns duplex-link $n0 $n2 0.5mb 10ms DropTail
$ns duplex-link $n1 $n2 0.5mb 10ms DropTail
$ns duplex-link $n2 $n3 0.5mb 10ms DropTail
$ns duplex-link $n3 $n4 0.5mb 10ms DropTail
$ns duplex-link $n3 $n5 0.5mb 10ms DropTail

# ping agents
set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0
set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4
set ping1 [new Agent/Ping]
$ns attach-agent $n1 $ping1
set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5

$ping0 set packetSize_ 500
$ping0 set interval_ 0.001
$ping1 set packetSize_ 500
$ping1 set interval_ 0.001
$ping4 set packetSize_ 500
$ping4 set interval_ 0.001
$ping5 set packetSize_ 500
$ping5 set interval_ 0.001

# UDP traffic from n0 to n4 to create congestion
set udp0 [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp0
$ns attach-agent $n4 $null
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_ 0.001
$cbr attach-agent $udp0
$ns connect $udp0 $null

$ping0 set class_ 1
$ping1 set class_ 2

# ping0 -> ping4 and ping1 -> ping5
$ns connect $ping0 $ping4
$ns connect $ping1 $ping5

# runs when a ping agent receives a reply
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "The node [$node_ id] received a reply from $from with round trip time of $rtt ms"
}

proc finish { } {
    global ns nf tf
    $ns flush-trace
    exec nam lab3.nam &
    close $tf
    close $nf
    exit 0
}

# send pings every 0.1 s from 0.1 to 1.0
foreach t {0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0} {
    $ns at $t "$ping0 send"
    $ns at $t "$ping1 send"
}
$ns at 0.2 "$cbr start"
$ns at 4.0 "$cbr stop"
$ns at 5.5 "finish"
$ns run
CNEOF
}

f_lab3_awk() {
cat <<'CNEOF'
BEGIN {
    count = 0
}
{
    if ($1 == "d")
        count++
}
END {
    printf("The Total no of Packets Dropped due to Congestion : %d\n", count)
}
CNEOF
}

f_lab4_tcl() {
cat <<'CNEOF'
set ns [new Simulator]
set tf [open lab4.tr w]
$ns trace-all $tf
set nf [open lab4.nam w]
$ns namtrace-all $nf

# create 4 nodes and put them on one Ethernet LAN
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns make-lan "$n0 $n1 $n2 $n3" 10mb 10ms LL Queue/DropTail Mac/802_3

# traffic 1: n0 -> n3 (TCP + FTP)
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp0 $sink3

# traffic 2: n2 -> n1 (TCP + FTP)
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp2 $sink1

# trace the congestion window
set file1 [open file1.tr w]
$tcp0 attach $file1
$tcp0 trace cwnd_
$tcp0 set maxcwnd_ 10
set file2 [open file2.tr w]
$tcp2 attach $file2
$tcp2 trace cwnd_

proc finish { } {
    global nf tf ns
    $ns flush-trace
    exec nam lab4.nam &
    close $nf
    close $tf
    exit 0
}

$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"
$ns at 2 "$ftp0 start"
$ns at 3 "$ftp0 stop"
$ns at 0.2 "$ftp2 start"
$ns at 2 "$ftp2 stop"
$ns at 2.5 "$ftp2 start"
$ns at 4 "$ftp2 stop"
$ns at 5.0 "finish"
$ns run
CNEOF
}

f_lab4_awk() {
cat <<'CNEOF'
{
    if ($6 == "cwnd_")
        printf("%f \t %f \n", $1, $7)
}
CNEOF
}

f_lab5_tcl() {
cat <<'CNEOF'
set ns [new Simulator]
set tf [open lab5.tr w]
$ns trace-all $tf
set nf [open lab5.nam w]
$ns namtrace-all $nf
$ns color 1 "red"

# create 7 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
$n1 label "Source/UDP"
$n3 label "Error Node"
$n5 label "Destination"

# two LANs, joined by a link between n3 (LAN1) and n6 (LAN2)
$ns make-lan "$n0 $n1 $n2 $n3" 10Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n4 $n5 $n6" 10Mb 10ms LL Queue/DropTail Mac/802_3
$ns duplex-link $n3 $n6 100Mb 10ms DropTail

# UDP + CBR from n1 to n5
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
set null5 [new Agent/Null]
$ns attach-agent $n5 $null5
$ns connect $udp1 $null5
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.0001   ;# data rate: change this
$udp1 set class_ 1

# error model on the n3-n6 link
set err [new ErrorModel]
$ns lossmodel $err $n3 $n6
$err set rate_ 0.2           ;# error rate: change this

proc finish { } {
    global nf ns tf
    $ns flush-trace
    exec nam lab5.nam &
    close $nf
    close $tf
    exit 0
}

$ns at 0.1 "$cbr1 start"
$ns at 5.0 "finish"
$ns run
CNEOF
}

f_lab5_awk() {
cat <<'CNEOF'
BEGIN {
    pkt = 0
    time = 0
}
{
    if ($1 == "r" && $3 == "8" && $4 == "5") {
        pkt = pkt + $6
        time = $2
    }
}
END {
    printf("Throughput: %f Mbps\n", (pkt / time) * (8 / 1000000))
}
CNEOF
}

IDS=(A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 B1 B2 B3 B4 B5)
TITLES=("Dijkstra's Algorithm (Shortest Path)" "CRC-CCITT (16-bit)" "Distance Vector Routing" "TCP Client-Server File Transfer" "Hamming Code" "Sliding Window Protocol" "FIFO Client-Server File Transfer" "UDP Client-Server File Transfer" "Leaky Bucket (Congestion Control)" "DNS" "3-node network: packets dropped" "TCP vs UDP: packets sent" "Ping: packets dropped (congestion)" "Ethernet LAN: congestion window" "Ethernet LAN: error rate, data rate, throughput")
FILES=("p1.cpp" "p2.cpp" "p3.cpp" "p4server.cpp p4client.cpp" "p5.cpp" "p6sender.cpp p6receiver.cpp" "p7server.cpp p7client.cpp" "p8server.cpp p8client.cpp" "p9.cpp" "p10.cpp" "lab1.tcl lab1.awk" "lab2.tcl lab2.awk" "lab3.tcl lab3.awk" "lab4.tcl lab4.awk" "lab5.tcl lab5.awk")
RUNS=($'g++ p1.cpp -o p1 && ./p1' $'g++ p2.cpp -o p2 && ./p2' $'g++ p3.cpp -o p3 && ./p3' $'g++ p4server.cpp -o server && g++ p4client.cpp -o client\n   Terminal 1: ./server     Terminal 2: ./client  (filename: hello.txt)' $'g++ p5.cpp -o p5 && ./p5' $'g++ p6sender.cpp -o sender && g++ p6receiver.cpp -o receiver\n   Terminal 1: ./sender     Terminal 2: ./receiver' $'g++ p7server.cpp -o fserver && g++ p7client.cpp -o fclient\n   Terminal 1: ./fserver    Terminal 2: ./fclient  (filename: hello.txt)' $'g++ p8server.cpp -o userver && g++ p8client.cpp -o uclient\n   Terminal 1: ./userver    Terminal 2: ./uclient  (filename: hello.txt)' $'g++ p9.cpp -o p9 && ./p9' $'g++ p10.cpp -o p10 && ./p10' $'ns lab1.tcl\n   awk -f lab1.awk lab1.tr' $'ns lab2.tcl\n   awk -f lab2.awk lab2.tr' $'ns lab3.tcl\n   awk -f lab3.awk lab3.tr' $'ns lab4.tcl\n   awk -f lab4.awk file1.tr > tcp1\n   awk -f lab4.awk file2.tr > tcp2\n   xgraph -x "time" -y "convalue" tcp1 tcp2      (or: gnuplot -p -e "plot \'tcp1\' w l, \'tcp2\' w l")' $'ns lab5.tcl\n   awk -f lab5.awk lab5.tr')
HELLO=(0 0 0 1 0 0 1 1 0 0 0 0 0 0 0)

fname_to_fn() { local f="$1"; echo "f_${f//./_}"; }

show_menu() {
    echo
    echo -e "${C}==================== CN LAB PROGRAMS ====================${N}"
    echo -e "${Y} PART A (C++)${N}"
    for i in $(seq 0 9);  do printf "  %2d) %-4s %s\n" $((i+1)) "${IDS[$i]}" "${TITLES[$i]}"; done
    echo -e "${Y} PART B (NS2)${N}"
    for i in $(seq 10 14); do printf "  %2d) %-4s %s\n" $((i+1)) "${IDS[$i]}" "${TITLES[$i]}"; done
    echo -e "${D}   q) quit${N}"
    echo -e "${C}=========================================================${N}"
}

show_code() {
    local i=$1
    for f in ${FILES[$i]}; do
        echo
        echo -e "${G}----------------------- $f -----------------------${N}"
        $(fname_to_fn "$f")
    done
    echo
}

save_files() {
    local i=$1
    for f in ${FILES[$i]}; do
        if [ -e "$f" ]; then
            read -r -p "  $f already exists. Overwrite? (y/n): " yn
            [ "$yn" != "y" ] && { echo "  $f skipped"; continue; }
        fi
        $(fname_to_fn "$f") > "$f"
        echo -e "  ${G}saved:${N} $PWD/$f"
    done
    if [ "${HELLO[$i]}" = "1" ] && [ ! -e hello.txt ]; then
        printf 'hi\nhello\nuvce\n' > hello.txt
        echo -e "  ${G}saved:${N} $PWD/hello.txt  (test file)"
    fi
}

while true; do
    show_menu
    read -r -p "Enter program number (1-15) or q to quit: " n
    [ "$n" = "q" ] || [ "$n" = "Q" ] && { echo "Bye!"; exit 0; }
    if ! [[ "$n" =~ ^[0-9]+$ ]] || [ "$n" -lt 1 ] || [ "$n" -gt 15 ]; then
        echo -e "${Y}Invalid input. Enter a number from 1 to 15.${N}"; continue
    fi
    i=$((n-1))
    echo
    echo -e "${C}${IDS[$i]}: ${TITLES[$i]}${N}"
    echo "  1) Show the code in the terminal"
    echo "  2) Save the files in this folder ($PWD)"
    echo "  3) Both"
    read -r -p "Choice (1/2/3): " c
    case "$c" in
        1) show_code $i ;;
        2) save_files $i ;;
        3) show_code $i; save_files $i ;;
        *) echo -e "${Y}Invalid choice.${N}"; continue ;;
    esac
    echo
    echo -e "${Y}How to run:${N}"
    echo -e "   ${RUNS[$i]}"
    read -r -p $'\nPress Enter to go back to the menu...' _
done
