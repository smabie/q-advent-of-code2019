/ 5.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
init:("J"$) each "," vs (read0 `:5.txt)[0] / instruction data
tape:0#0

res_param:{[mode; val] $[mode=1; val; tape[val]]}
pars:{(res_param/) each (neg z) _ flip (x; y)}

op_add:{op_gen[x; y; sum]; 0N}
op_mul:{op_gen[x; y; prd]; 0N}
op_read:{x; y; 1">>> "; tape[first y]:"J"$read0 0; 0N}
op_show:{0N!res_param over x,y; 0N}
op_jit:{$[0<>first xs:pars[x; y; 0]; last xs; 0N]}
op_jif:{$[0=first xs:pars[x; y; 0]; last xs; 0N]}
op_lt:{xs:pars[x; y; 1]; tape[last y]:$[xs[0]<xs[1]; 1; 0]; 0N}
op_eql:{xs:pars[x; y; 1]; tape[last y]:$[xs[0]=xs[1]; 1; 0]; 0N}

ops:1 2 3 4 5 6 7 8!((op_add; 3); (op_mul; 3); (op_read; 1);
 (op_show; 1); (op_jit; 2); (op_jif; 2); (op_lt; 3); (op_eql; 3))

op_gen:{[info; values; f]
 tape[last values]: f pars[info; values; 1]}

read_op:{xs:((2-count op+len:(ops[last op])[1])#0),op:10 vs x;
 (10 sv len _ ys),reverse (neg 2) _ ys:((2+len-count op)#0),op}

run_op:{[op_info; values] f:ops[first op_info][0]; f[1 _ op_info; values]}

step:{if[x=-99999; :-99999];
 if[99=op:tape[x]; :-99999]; len:last ops[first info:read_op op]; 
 $[0N<>a:run_op[info; (x+1; len) sublist tape]; a; x+len+1]}

run:{tape::init; step scan 0;}

run[]
run[]

exit 0
