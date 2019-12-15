/ 9.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

map:("#"=) each read0 `:10.txt
coords:raze ((where 1b=) each map) cross' til count map
idxs:til count coords

slope:{s:((%/)x-y); d:sum abs x-y;
 $[x[1]<y[1]; (`b; s); (`a; s)],d} / up=a, down=b


visible:{p:coords[x]; -1+count distinct (-1_) each slope[p;] each coords}


/ return visible number and asteroid coordinates
asteroid:{m,enlist x v?m:max v:visible each til count x}


find:{slope[x;] each coords}


quads:({(x[0]=`a) and x[1]<=0}; {(x[0]=`b) and x[1]>=0};
 {(x[0]=`b) and x[1]<0}; {(x[0]=`a) and x[1]>0})

info:t where (not (`a; 0n; 0)~) each t:find last asteroid coords
order:raze {desc x where y each x}[info;] each quads
map:{asc {order x} each x} each value group (-1_) each order
rots:raze {map[;x]} each til max count each map
laser_order:rots where 0N<>last each rots

astr:{coords info?laser_order x-1}

part1 first asteroid coords
part2 sum (100; 1)*astr 200
