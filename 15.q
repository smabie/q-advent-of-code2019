/ 15.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q
init:("J"$) each "," vs (read0 `:15.txt)[0] / instruction data
unit:-1
end:-2
board:(50; 100)#" "

coord:25 50
start:coord

left_turn:(1 0; 0 -1; -1 0; 0 1)!(0 -1; -1 0; 0 1; 1 0)
right_turn:value[left_turn]!key left_turn
turn:(left_turn; right_turn)

dir:1 2 3 4!((1; 0); (-1; 0); (0; -1); (0; 1)) /n=1, s=2, w=3, e=4
cdir:value[dir]!key dir
d:0 -1

board[coord[0]; coord[1]]:"."

/ resolve value parameters 
resolve:{[amp; mode; val]
 $[mode=1; val;                                    / immediate mode
  mode=2; get_tape[amp;] val+get_prop[amp; `base]; / relative base mode
  get_tape[amp; val]]}                             / position mode

/ generate values for each parameter, should not be used for assignment 
params:{[amp; x; y; z] (resolve[amp;;]/) each (neg z) _ flip (x; y)} / resolve first n params 

/ add/mul higher-order function
gen_am:{[amp; info; values; f]
 mod_tape[amp; last values; last info;] f params[amp; info; values; 1]; unit}

/ jump-if-true/jump-if-false higher-order function
gen_jj:{[amp; info; values; f] xs:params[amp; info; values; 0];
 $[not f[0; first xs]; unit; last xs]}

/ less-than/equal higher-order function
gen_le:{[amp; info; values; f] xs:params[amp; info; values; 1];
 mod_tape[amp; last values; last info;] $[f[xs[0]; xs[1]]; 1; 0]; unit}

op_add:{gen_am[x; y; z; sum]}   / 1,x,y,z -> z=x+y
op_mul:{gen_am[x; y; z; prd]}   / 2,x,y,z -> z=x*y

op_read:{[amp; info; values]    / 3,x -> x<-input
 mod_tape[amp; first values; first info;] cdir d; unit}

op_show:{[amp; info; values]    / 4,x -> output<-x
 code:resolve[amp;] over info,values;
 if[code=0; t:coord+d; board[t[0]; t[1]]:"#"; d::left_turn d];
 if[code=1; coord+:d; board[coord[0]; coord[1]]:"."; d::right_turn d];
 if[code=2; coord+:d; board[coord[0]; coord[1]]:"O"; d::right_turn d];
 $[coord~start; end; unit]}

op_jit:{gen_jj[x; y; z; <>]}    / 5,x,y -> jmp y if x!=0
op_jif:{gen_jj[x; y; z; =]}     / 6,x,y -> jmp y if x=0
op_lt:{gen_le[x; y; z; <]}      / 7,x,y -> z=x<y
op_eql:{gen_le[x; y; z; =]}     / 8,x,y -> z=x=y

op_base:{[amp; info; values]    / 9,x   -> BASE=x
 mod_prop[amp; `base;] get_prop[amp; `base]+(resolve[amp;] . info,values); unit}

/ instruction table
ops:1 2 3 4 5 6 7 8 9!((op_add; 3); (op_mul; 3); (op_read; 1);
 (op_show; 1); (op_jit; 2); (op_jif; 2); (op_lt; 3); (op_eql; 3);
 (op_base; 1))

/ parse opcode 
read_op:{xs:((2-count op+len:(ops[last op])[1])#0),op:10 vs x;
 (10 sv len _ ys),reverse (neg 2) _ ys:((2+len-count op)#0),op}

/ run opcode 
run_op:{[amp; op_info; values] f:ops[first op_info][0]; f[amp; 1 _ op_info; values]}

/ execute instruction
step:{[amp] idx:get_prop[amp; `idx];
 if[99=op:get_tape[amp; idx]; :`end];
 
 len:last ops[first info:read_op op];
 mod_prop[amp; `idx;] idx+len+1;
 $[unit=r:run_op[amp; info;] (idx+1; len) sublist get_prop[amp; `tape]; amp;
  -2=r; `end;
  mod_prop[amp; `idx; r]]}

/ run machine until exiting
run:{[sym]
 cur:sym;
 while[cur<>`end; cur:step cur];
 }

/ create dictionary that stores tape state
/       tape - the instruction tape
/       len  - length of tape
/       base - relative base offset (mode 2)
/       idx  - current instruction pointer location
mk_tape:{[sym] sym set `tape`len`base`idx!(init; count init; 0; 0)}

/ extend the tape if necessary
extend_tape:{[amp; idx]
 if[idx>=len:get_prop[amp; `len];
  @[amp; `tape; :;] @[(idx+1)#0; til len; :;] get_prop[amp; `tape];
  mod_prop[amp; `len;] idx+1];
 }

/ get dictionary property
get_prop:{[amp; sym] get[amp]sym}

/ modify property
mod_prop:{[amp; sym; val] @[amp; sym; :; val]} 

/ modify tape, add relative base to index if mode=2
mod_tape:{[amp; idx; mode; val] 
 addr:idx+$[mode=2; get_prop[amp; `base]; 0];           
 extend_tape[amp; addr]; .[amp; (`tape; addr); :; val]} 

/ return value at specified tape index 
get_tape:{[amp; idx] extend_tape[amp; idx]; get[amp][`tape]idx}

run mk_tape `a
board:{ssr[x; " "; "#"]} each {-30_ 29_ x} each -3_ 6_ board

pos:key cdir
oxys:enlist oxy:39 39
n:n

new_oxygen:{distinct raze {p where "."=(board .) each p:pos+\:x} each x}
advance:{n+:1; {.[`board; x; :; "O"]; x} each oxys,:new_oxygen x}

advance over oxys;
part2 n-1;
