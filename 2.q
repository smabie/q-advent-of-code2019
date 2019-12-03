init:("I"$) each "," vs (read0 `:2.txt)[0]
tape:init 
seq:til (count init)
comb:seq cross seq
output:19690720

/ run the intstruction at address x
step:{op:tape[x]; arg1:tape[x+1]; arg2:tape[x+2]; dst:tape[x+3];
 if[op=99; :-1]; if[x=-1; :-1];
 tape[dst]:$[op=1; +; *][tape[arg1]; tape[arg2]];
 x+4}

/ run the machine until we converge on -1, resetting the tape each run
run:{[xs]
 tape[1]:xs[0];
 tape[2]:xs[1];
 step scan 0;
 ret:tape[0];
 tape::init;
 ret}

/ find the noun and verb that produces output
find:{nv:comb[(run each comb)?output];
 noun:nv[0]; verb:nv[1];
 verb+100*noun}

" " sv ("Part 1:"; string run (12; 2))
" " sv ("Part 2:"; string find[])

exit 0



