/ 5.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

init:("J"$) each "," vs (read0 `:5.txt)[0] / instruction data
tape:0#0

op_add:{op_gen[x; y; sum]}
op_mul:{op_gen[x; y; prd]}
op_read:{[info; values] 1">>> "; tape[first values]:"J"$read0 0}
op_show:{[info; values] 0N!res_param over info,values}

///
/op_jit:{[info; values] xs:(res_param/) each flip (info; values);
/ $[first xs<>0; last xs; -1]}
/op_jif:{[info; values] xs:(res_param/) each flip (info; values);
/ $[first xs=0; last xs; -1]}
///

ops:1 2 3 4!((op_add; 3); (op_mul; 3); (op_read; 1); (op_show; 1))

res_param:{[mode; val] $[mode=1; val; tape[val]]}
op_gen:{[info; values; f]
 tape[last values]: f (res_param/) each (neg 1) _ flip (info; values);}

read_op:{xs:((2-count op+len:(ops[last op])[1])#0),op:10 vs x;
 (10 sv len _ ys),reverse (neg 2) _ ys:((2+len-count op)#0),op}

run_op:{[op_info; values] f:ops[first op_info][0]; f[1 _ op_info; values]}

step:{if[x=0N; :0N];
 if[99=op:tape[x]; :0N]; len:last ops[first info:read_op op]; 
 run_op[info; ((x+1); len) sublist tape];
 x+len+1}

run:{tape::init; step scan 0;}

part1 run[]
