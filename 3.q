/ 3.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

wires:{"," vs x} each read0 `:3.txt / wire spec

/ generate a list of coordinates
section:{len:"J"$(1 _ x);
 basis:$["R"=dir:x[0]; (1; 0); dir="L"; (-1; 0); dir="U"; (0; 1); (0; -1)];
 (0N; 2)#(2*len)#basis}

/ generate wire paths
expand:{sums (0N; 2)#raze over section each x}

/ find closest intersection using manhattan distance
manhattan_distance:{min sum abs flip (inter/) expand each x}

/ find closest intersection using sum of wire length
locs:{2+min sum w?\:((inter/) w:expand each x)}

part1 manhattan_distance wires
part2 locs wires

exit 0
