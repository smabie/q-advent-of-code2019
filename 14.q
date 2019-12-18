/ 14.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

parser:{{raze (" " vs) each x} each (", " vs) each ssr[; " =>"; ","] each x}
recipe:{reverse flip @[@[flip 2 cut x; 0; "J"$]; 1; "S"$]} each parser read0 `:131.txt
dict:()!()

mk_dict:{{dict[x[0; 1]]:x[0; 0],1 _ x} each x; dict}
mk_dict recipe

gen:{$[`ORE<>x; first[d],{(first[x]; gen[last x])} each 1 _ d:dict[x]; x]}

