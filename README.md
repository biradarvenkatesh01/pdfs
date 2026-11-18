# CN Lab (5th Sem)

Computer Networks lab programs: Part A (C++) and Part B (NS2), with a menu script, a printable manual and a study guide.

## Quick start: get the program menu

Run this in any folder. It downloads `cnlab.sh` into that folder and opens the menu:

```bash
curl -sLO https://raw.githubusercontent.com/biradarvenkatesh01/pdfs/main/cnlab.sh && bash cnlab.sh
```

If `curl` is not installed, use `wget`:

```bash
wget -q https://raw.githubusercontent.com/biradarvenkatesh01/pdfs/main/cnlab.sh && bash cnlab.sh
```

The menu lists all 15 programs. Pick a number, then choose to show the code, save that program's files in the current folder, or both.

## Get everything

```bash
git clone https://github.com/biradarvenkatesh01/pdfs cnlab
```

## Contents

| Path | What it is |
|---|---|
| `cnlab.sh` | Menu script: show or save any program |
| `cnlab_setup.sh` | VM setup (Ubuntu/Kali): installs g++, ns2, nam, gnuplot, fixes NAM, writes all programs to `~/cnlab` |
| `CN_Lab_Programs_Manual.pdf` | Black and white manual: every program with how to run and tested output |
| `CN_Lab_Complete_Guide.pdf` | Full study guide: basics, setup, explanations, viva questions |
| `partA/` | A1–A10 C++ programs (`p1.cpp` ... `p10.cpp`) and `hello.txt` test file |
| `partB/` | B1–B5 NS2 programs (`lab1.tcl` + `lab1.awk` ... `lab5`) |

## Programs

| No. | Program | Files |
|---|---|---|
| A1 | Dijkstra's shortest path | `p1.cpp` |
| A2 | CRC-CCITT (16-bit) | `p2.cpp` |
| A3 | Distance vector routing | `p3.cpp` |
| A4 | TCP client-server file transfer | `p4server.cpp`, `p4client.cpp` |
| A5 | Hamming code | `p5.cpp` |
| A6 | Sliding window protocol | `p6sender.cpp`, `p6receiver.cpp` |
| A7 | FIFO client-server file transfer | `p7server.cpp`, `p7client.cpp` |
| A8 | UDP client-server file transfer | `p8server.cpp`, `p8client.cpp` |
| A9 | Leaky bucket congestion control | `p9.cpp` |
| A10 | DNS lookup | `p10.cpp` |
| B1 | 3-node network, packets dropped | `lab1.tcl`, `lab1.awk` |
| B2 | TCP vs UDP packets sent | `lab2.tcl`, `lab2.awk` |
| B3 | Ping over 6 nodes, drops due to congestion | `lab3.tcl`, `lab3.awk` |
| B4 | Ethernet LAN congestion window | `lab4.tcl`, `lab4.awk` |
| B5 | Ethernet LAN error rate, data rate, throughput | `lab5.tcl`, `lab5.awk` |

## How to run

**Part A:** `g++ p1.cpp -o p1 && ./p1`. Client-server programs need two terminals; start the server first.

**Part B:** `ns lab1.tcl`, then `awk -f lab1.awk lab1.tr`.

All Part A programs use standard headers only (no `bits/stdc++.h`) and compile with `g++ -std=c++98`. All outputs in the PDFs come from real runs (Part B on NS2 2.35).
