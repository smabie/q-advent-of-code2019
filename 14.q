/ 14.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

parser:{{raze (" " vs) each x} each (", " vs) each ssr[; " =>"; ","] each x}
recipe:{reverse flip @[@[flip 2 cut x; 0; "J"$]; 1; "S"$]} each parser read0 `:14.txt

mk_table:{{`chems insert (last first x; 0N; first first x; 1_ x)} each x}

rank_chem:{[sym] $[any {`ORE=last x} each v:chems[sym; `input]; 1; sum {1+rank_chem last x} each v]}
rank_table:{update order:(rank_chem each select name from chems) from chems}

mk_store:{names!count[names:@[;`name] select name from chems]#0}

get_output:{[sym] first @[;`output] select output from chems where name=sym}
get_order:{[sym] first @[;`order] select order from chems where name=sym}
get_input:{[sym] first @[;`input] select input from chems where name=sym}
is_base:{[sym] 1=get_order sym}

mk_chem:{[sym; n]
 store[sym]+:o*t:ceiling n%o:get_output sym;
 $[is_base sym;
  total+:t*.[;0 0] get_input sym;
  {store[last x]-:first x} each flip @[flip get_input sym; 0; (t*)]];
 }

mk:{[sym; n]
 amt:store[sym];
 if[b:sym=`FUEL; mk_chem[sym; n]];
 if[not b;
  if[0>amt; mk_chem[sym; abs amt]]];}

chems:([name:()] order:(); output:(); input:())
mk_table recipe;
chems:rank_table[]

total:fuel:0
store:mk_store[]

run:{[n]
 fuel::0; total::0; store::mk_store[];
 '[mk[;n]; last] each desc select order,name from chems; store[`FUEL]:0; fuel+:1; total}


t:1000000000000
mx:floor 2*t%run 1

search:{
 lo:x[0]; mid:x[1]; hi:x[2];
 $[(t>run[mid+1]) and b:t<run mid; total;
  b; (lo; floor (lo+mid)%2; mid); (mid; floor (mid+hi)%2; hi)]}

part1 run 1
part2 @[;1] search over (1; floor mx%2; mx)
