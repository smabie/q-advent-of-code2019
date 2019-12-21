/ 6.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

map:(("S"$) each) each (")" vs) each read0 `:6.txt
dict:syms!count[syms:distinct raze map]#();
{dict[x[0]]:x[1],dict[x[0]]} each map; / build tree

/ sum orbits
orbits:{n:count xs:dict[x]; $[n=0; y; y+sum .z.s[; y+1] each xs]}

/ find path from system y from root system x
find:{{n:count xs:dict[x];
  $[n<>xs?y; x,z; n=0; (); raze .z.s[; y; x,z] each xs]}[x; y; ()]}

/ find min jumps
jumps:{min sum (x; y)?\:x inter y}

part1 orbits[`COM; 0]
part2 jumps[find[`COM; `YOU]; find[`COM; `SAN]]

exit 0
