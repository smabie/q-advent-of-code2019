/ 7.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q
init:("J"$) each "," vs (read0 `:7.txt)[0] / instruction data
tape:0#0
phase:0
output:0
unit:-1
state:0b 

resolve:{[mode; val] $[mode=1; val; tape[val]]} / resolve position or immediate mode
params:{(resolve/) each (neg z) _ flip (x; y)} / resolve first n params 

gen_am:{[info; values; f] tape[last values]:f params[info; values; 1]}
gen_jj:{$[z[0; first xs:params[x; y; 0]]; last xs; unit]}
gen_le:{xs:params[x; y; 1]; tape[last y]:$[z[xs[0]; xs[1]]; 1; 0]; unit}

op_add:{gen_am[x; y; sum]; unit}
op_mul:{gen_am[x; y; prd]; unit}

/ very ugly solution
op_read:{
 tape[first y]:$[state=0b; phase; output];
 state::not state; unit}

op_show:{output::resolve over x,y; unit}
op_jit:{gen_jj[x; y; <>]}
op_jif:{gen_jj[x; y; =]}
op_lt:{gen_le[x; y; <]}
op_eql:{gen_le[x; y; =]}

/ instruction table
ops:1 2 3 4 5 6 7 8!((op_add; 3); (op_mul; 3); (op_read; 1);
 (op_show; 1); (op_jit; 2); (op_jif; 2); (op_lt; 3); (op_eql; 3))

/ parse opcode 
read_op:{xs:((2-count op+len:(ops[last op])[1])#0),op:10 vs x;
 (10 sv len _ ys),reverse (neg 2) _ ys:((2+len-count op)#0),op}

/ run opcode 
run_op:{[op_info; values] f:ops[first op_info][0]; f[1 _ op_info; values]}

step:{if[x=0N; :0N];
 if[99=op:tape[x]; :0N]; len:last ops[first info:read_op op]; 
 $[unit<>a:run_op[info; (x+1; len) sublist tape]; a; x+len+1]}


run:{tape::init;
 phase::x;
 step scan 0;
 }

/ permutations 
perm:{(1 0#x){raze(1 rotate)scan'x,'y}/x}

thruster:{run each x; t:output; output::0; t}
high_signal:{max thruster each x}

part1 high_signal[perm 0 1 2 3 4]
