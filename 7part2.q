/ 7part2.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q
init:("J"$) each "," vs (read0 `:7.txt)[0] / instruction data
unit:-1
amp:0#`
n_amps:5
switch:-2
resolve:{[amp; mode; val] $[mode=1; val; get_tape[amp]val]} / resolve position or immediate mode
params:{[amp; x; y; z] (resolve[amp;;]/) each (neg z) _ flip (x; y)} / resolve first n params 

gen_am:{[amp; info; values; f] mod_tape[amp; last values;] f params[amp; info; values; 1]}
gen_jj:{[amp; x; y; z] $[z[0; first xs:params[amp; x; y; 0]]; last xs; unit]}
gen_le:{[amp; x; y; z]
 xs:params[amp; x; y; 1]; mod_tape[amp; last y;] $[z[xs[0]; xs[1]]; 1; 0]; unit}

op_add:{[amp; x; y] gen_am[amp; x; y; sum]; unit}
op_mul:{[amp; x; y] gen_am[amp; x; y; prd]; unit}

op_jit:{[amp; x; y] gen_jj[amp; x; y; <>]}
op_jif:{[amp; x; y] gen_jj[amp; x; y; =]}
op_lt:{[amp; x; y] gen_le[amp; x; y; <]}
op_eql:{[amp; x; y] gen_le[amp; x; y; =]}

/ very ugly solution
op_read:{[amp; x; y]
 mod_tape[amp; first y;] $[b:0b=get_prop[amp; `state]; get_prop[amp; `phase]; prev_out amp];
 if[b; toggle_amp[amp]]; unit}

op_show:{[amp; x; y] mod_prop[amp; `output;] resolve[amp;] over x,y; switch}

/ instruction table
ops:1 2 3 4 5 6 7 8!((op_add; 3); (op_mul; 3); (op_read; 1);
 (op_show; 1); (op_jit; 2); (op_jif; 2); (op_lt; 3); (op_eql; 3))

/ parse opcode 
read_op:{xs:((2-count op+len:(ops[last op])[1])#0),op:10 vs x;
 (10 sv len _ ys),reverse (neg 2) _ ys:((2+len-count op)#0),op}

/ run opcode 
run_op:{[amp; op_info; values] f:ops[first op_info][0]; f[amp; 1 _ op_info; values]}

step:{[amp] idx:get_prop[amp; `idx];
 if[(amp=`a) and 99=op:get_tape[amp]idx; :`end];
 if[99=op; toggle_amp[amp]; :next_amp[amp]];
 
 len:last ops[first info:read_op op];
 mod_prop[amp; `idx;] idx+len+1;
 $[unit=r:run_op[amp; info;] (idx+1; len) sublist get_tape[amp]; amp;
  r=switch; next_amp amp;
  mod_prop[amp; `idx; r]]}

run:{[amp]
 cur:amp; 
 while[cur<>`end; cur:step cur];
 get_prop[`e; `output]}

mk_amp:{[sym; ph] sym set `tape`phase`output`idx`state`halt!(init; ph; 0; 0; 0b; 0b)}

toggle_amp:{@[x; `state; :; not get[x][`state]]}
get_prop:{[amp; sym] get[amp]sym}
mod_prop:{[amp; sym; val] @[amp; sym; :; val]}
mod_tape:{[amp; idx; val] .[amp; (`tape; idx); :; val]}
get_tape:{[amp] get[amp][`tape]}

prev_out:{[amp] get_prop[;`output] amps mod[;n_amps] -1+amps?amp}

gen_amps:{[phases] (mk_amp .) each `a`b`c`d`e,'phases}
next_amp:{[amp] amps mod[;n_amps] 1+amps?amp}

perm:{(1 0#x){raze(1 rotate)scan'x,'y}/x}

find:{[xs] max {amps::gen_amps x; run `a} each xs}

part2 find[perm 5 6 7 8 9]
