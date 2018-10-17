

productions =
[
E  = [[:T,:E,:ER]],
ER = [[1,:T,:ER],[EPISILON]],

T  = [[:F,:T]],
TR = [[2,:F,:TR],[EPISILON]],

F  = [[3],[ID]],
TEMP = [[TR,TR]]
]