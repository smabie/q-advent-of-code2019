/ 0.q
/ Advent of Code 2019
/ Utility functions

amend:{t:get x; t[y]:z; x set t; z}

prn:{0N!" " sv ("Part"; string x; "solution:"; string y);}
part1:{prn[1;x]}
part2:{prn[2;x]}
