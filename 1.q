/ 1.q
/ Advent of Code 2019
/ Public domain as declared by Sturm Mabie

masses:("I"$) each read0 `:1.txt / mass data
fuel:{-2+floor x%3}
fuel_list:fuel masses
rec_fuel:(-2 _) each (fuel scan) each fuel_list / remove last two values

" " sv ("Part 1:"; string sum fuel_list)
" " sv ("Part 2:"; string sum sum each rec_fuel)

exit 0
get rid of last two negative fuel values
