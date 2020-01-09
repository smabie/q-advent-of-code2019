/ 17.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q
init:("J"$) each "," vs (read0 `:17.txt)[0] / instruction data
unit:-1

board:()
dir:((1; 0); (-1; 0); (0; 1); (0; -1))

op_view:{[amp; info; values]    
 board,:("c"$)resolve[amp;] over info,values; unit}

/ instruction table
ops:1 2 3 4 5 6 7 8 9!((op_add; 3); (op_mul; 3); (op_read; 1);
 (op_view; 1); (op_jit; 2); (op_jif; 2); (op_lt; 3); (op_eql; 3);
 (op_base; 1))

run mk_tape `a

board:"\n" vs board
y:count board
x:count first board

coords:til[y] cross til x

crossings:{x where {("#"=board . x) and all ('[;]/[("#"=; board .; x+)]) each dir} each x}

find:{sum (*/') crossings x}

part1 find coords
