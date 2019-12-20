/ 8.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q
width:25
height:6
layers:100
image:(layers; height; width)#(("J"$) each string read0 `:8.txt) 0

calc:{[img] idx:xs?min xs:sum each {0=raze x} each img;
 (sum 2=ys)*sum 1=ys:raze img idx}

/ find color 0:black, 1:white, 2:transparent
color:{first x except 2}

/ rotate across dimensions then flatten, find top color, and reshape
decode:{(height; width)#color each raze flip each flip x}

part1 calc image
part2
decode image

exit 0
