/ 12.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

init:("=" vs) each raze['[;]/[("," vs; (1 _); (-1 _))] each read0 `:12.txt]
pos:3 cut ("J"$) each last flip init
vel:(floor count[init]%3; 3)#0

/ return 0, -1, or 1 depending on whether a < b
adj:{$[.[=]x; 0; .[<]x; 1; -1]}

/ calculate gravity affect 
gravity:{'[;]/[(adj each; flip; count[flip x] cut)] each x cross x}

/ takes previous state, returns next state
step:{(p+v; v:last[x]+sum each count[p] cut gravity p:first x)}

/ find total energy given (pos; vel)
total:{sum prd (sum each) each abs x}

/ find total energy after x steps with initial pos=y and vel=z
energy:{total x step/(y; z)}

/ step function for just single dimension
single:{(p+v; v:last[x]+sum each count[p] cut adj each p cross p:first x)}

/ Euclid's gcd method
gcd:{[a;b] first {(x[1]; x[0] mod x[1])}/[{0<>x[1]}; (a; b)]}

/ lcm using gcd
lcm:{{floor (x*y)%gcd[x; y]}/[x]}

/ find cycle length for each component and then use lcm 
total_cycle:{lcm {count single\[x]} each flip (flip x; flip y)}

part1 energy[1000; pos; vel]
part2 total_cycle[pos; vel]
