/ 9.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

map:("#"=) each read0 `:10.txt
coords:raze ((where 1b=) each map) cross' til count map
idxs:til count coords

/ finds position (up=a, down=b), 'slope', and manhattan distance
slope:{s:((%/)x-y); $[x[1]<y[1]; (`b; s); (`a; s)],sum abs x-y}

visible:{p:coords[x]; -1+count distinct (-1_) each slope[p;] each coords}

/ return visible number and asteroid coordinates
asteroid:{m,enlist x v?m:max v:visible each til count x}

/ given a coordinate, find slope of all asteroids
find:{slope[x;] each coords}

/ sorting criteria for each quadrant 
quads:({(x[0]=`a) and x[1]<=0}; {(x[0]=`b) and x[1]>=0};
 {(x[0]=`b) and x[1]<0}; {(x[0]=`a) and x[1]>0})

/ distance information of asteroid with best visibility
info:t where (not (`a; 0n; 0)~) each t:find last asteroid coords

/ sorted list of asteroids based on angle 
order:raze {desc x where y each x}[info;] each quads

/ 2 dimensional sorted list of asteroids
map:{asc {order x} each x} each value group (-1_) each order

/ sorted list of asteroid laser targets
laser_order:rots where 0N<>last each rots:raze {map[;x]} each til max count each map

/ find nth laser hit
astr:{coords info?laser_order x-1}

part1 first asteroid coords
part2 sum (100; 1)*astr 200

exit 0
