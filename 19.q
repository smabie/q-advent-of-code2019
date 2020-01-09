/ 17.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

init:("J"$) each "," vs (read0 `:19.txt)[0] / instruction data

state:0b
idx:0
total:0
n:50
board:(n; n)#"."

op_read19:{[amp; info; values]    / 3,x -> x<-input
 pos:$[not state; first; last] coords idx;
 if[state; idx+:1];
 state::not state;
 mod_tape[amp; first values; first info;] pos; unit}

op_show19:{[amp; info; values]    / 4,x -> output<-x
 total+:b:resolve[amp;] over info,values;
 if[b; board[coords[idx]0; coords[idx]1]:"#"]
 unit}

coords:{x cross x} til n
/coords:enlist (25; 0)
ops:1 2 3 4 5 6 7 8 9!((op_add; 3); (op_mul; 3); (op_read19; 1);
 (op_show19; 1); (op_jit; 2); (op_jif; 2); (op_lt; 3); (op_eql; 3);
 (op_base; 1))

do[n*n; run mk_tape `a]

part1 sum "#"=raze board

