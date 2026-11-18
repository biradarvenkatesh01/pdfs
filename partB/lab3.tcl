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
