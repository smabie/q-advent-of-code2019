/ 3.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie

wires:{"," vs x} each read0 `:3.txt / wire spec

/ generate a list of coordinates
section:{dir:x[0]; len:"J"$(1 _ x);
 coord:$[dir="R"; (1; 0); dir="L"; (-1; 0); dir="U"; (0; 1); (0; -1)];
 (0N; 2)#(2*len)#coord};

/ generate wire paths
expand:{sums (0N; 2)#raze over section each x}

/ find closest intersection using manhattan distance
manhattan_distance:{min sum flip (inter/) expand each x}

/ find closest intersection using sum of wire length
locs:{w:expand each x; 2+min sum w?\:((inter/) w)}

" " sv ("Part 1:"; string manhattan_distance wires)
" " sv ("Part 2:"; string locs wires)

exit 0
