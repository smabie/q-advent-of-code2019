masses:("I"$) each read0 `:1.txt
fuel:{(floor x%3)-2}
fuel_list:fuel masses
rec_fuel:(-2 _) each (fuel scan) each fuel_list

" " sv ("Part 1:"; string sum fuel_list)
" " sv ("Part 2:"; string sum sum each rec_fuel)

exit 0
