/ 2.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

init:("I"$) each "," vs (read0 `:2.txt)[0] / instruction data
output:19690720 / magic number to find for part 2 
tape:0#0 
seq:til count init
comb:seq cross seq

/ run the instruction at address x
step:{if[x=-1; :-1];
 if[99=op:tape[x]; :-1];
 src1:tape[x+1]; src2:tape[x+2]; dst:tape[x+3];
 tape[dst]:$[op=1; +; *][tape[src1]; tape[src2]];
 x+4}

/ run the machine until we converge on -1, resetting the tape each run
run:{[xs]
 tape::init;
 tape[1]:xs[0]; tape[2]:xs[1];
 step scan 0;
 ret:tape[0];
 ret}

/ find the noun and verb that produces output and compute the magic number
find:{nv:comb[(run each comb)?output];
 noun:nv[0]; verb:nv[1];
 verb+100*noun}

part1 run (12; 2)
part2 find[]

exit 0



