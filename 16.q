/ 16.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie
\l 0.q

input:("J"$) each flip read0 `:16.txt
base:0 1 0 -1

/ generate pattern given a length and index
pattern:{[len; idx] 1_(len+1)#base where 4#idx}

/ calculate a single digit of the new phase
single:{[len; xs; idx]; mod[;10] abs sum pattern[len; idx]*xs}

/ generate the new phase
phase:{[len; xs; tils] single[len; xs;] peach tils}

/ find the 8 digits for phase n
find:{[n; xs] tils:1+til len:count xs; 10 sv 8#n phase[len;;tils]/ xs}

/ find the 8 digits for phase n at the first 7 digit offset 
find2:{[n; xs] ys:reverse (10 sv 7#input) _ (10000*count xs)#xs;
 10 sv 8#reverse n {mod[;10] peach sums x}/ ys}

part1 find[100; input]
part2 find2[100; input]

