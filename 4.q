/ 4.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie

/ password is between these two numbers
\l 0.q

low_end:206938
high_end:679128
range:low_end+til 1+high_end-low_end
nums:flip {10 vs x} range

/ return list of number of consecutive elements
cont_count:{count each(where differ x)cut x}

/ return boolean if number is strictly increasing
increasing:{"b"${$[x=0b; 0b; x<=y; y; 0b]} over x}

/ return boolean if number has atleast one double digit
/ we have to use -1 since 1b=1
adjacent:{0<sum 1<cont_count x}

/ only one double digit
only_two:{(count cnt)<>(cnt:cont_count x)?2}

valid:{(increasing each x) and (adjacent each x)}
valid2:{(only_two each x) and y}

part1 sum v:valid nums
part2 sum valid2[nums;v]
