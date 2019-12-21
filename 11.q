/ 11.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q
init:("J"$) each "," vs (read0 `:11.txt)[0] / instruction data
/init:("J"$) each "," vs "1102,34915192,34915192,7,4,7,99,0"
/init:("J"$) each "," vs "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
unit:-1
state:0b                        / color to paint the panel, direction the robot should turn

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

/op_read:{[amp; info; values]    / 3,x -> x<-input
/ mod_tape[amp; first values; first info;] "j"$0<sum coord in color[1]; unit}

op_read:{[amp; info; values]    / 3,x -> x<-input
 mod_tape[amp; first values; first info;] "j"$not 0<sum coord in color[0]; unit}

op_show:{[amp; info; values]    / 4,x -> output<-x
 cmd:resolve[amp;]. info,values;
 $[not state; color[cmd],:enlist coord; coord+:dir::turn[cmd] dir];
 if[not state;
  color[i]:color[i] where not (coord~) each color[i:not cmd];
  order,:enlist (cmd; -1+count color cmd)];
 state::not state; unit}

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
  mod_prop[amp; `idx; r]]}

/ run machine until exiting
run:{cur:mk_amp `a; 
 while[cur<>`end; cur:step cur];
 count distinct raze color}

/ create dictionary that stores tape state
/       tape - the instruction tape
/       len  - length of tape
/       base - relative base offset (mode 2)
/       idx  - current instruction pointer location
mk_amp:{[sym] sym set `tape`len`base`idx!(init; count init; 0; 0)}

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


color:((());(())) / 0 black, 1 white

coord:0 0                       
dir:0 1                         

order:()

left_turn:(0 1; -1 0; 0 -1; 1 0)!(-1 0; 0 -1; 1 0; 0 1)
right_turn:value[left_turn]!key left_turn
turn:(left_turn; right_turn)

part1 run[]


flipd:flip (0; 0),raze color
dim:abs reverse (1; 1)+(max each flipd)-min each flipd
canvas:dim#1

shifted_color:{{x+abs min each flipd} each x} each color

brush:flip[order][0],'{shifted_color . x} each order

{[xs] col:xs[0]; x:xs[1]; y:xs[2]; canvas[y; x]:col; xs} each brush;

part2 ""
'[0N!; {{$[x; "#"; " "]} each x}] each reverse canvas;

exit 0
