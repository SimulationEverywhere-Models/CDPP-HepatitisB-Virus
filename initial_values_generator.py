import itertools as it
import random as rn
import math

## Define probabilities for each type of cell value
PROBTABLE = [
    [30, 1], 
    [25, 2], 
    [20, 3],
    [15, 4],
    [8, 5],
    [2, 6]
]

A_LIST = range(10) # = [0, 1, ..., 9]
B_LIST = range(10) # = [0, 1, ..., 9]
WRITEFORMAT = "({},{})={}"

def tableposition(n):
    prob = 0
    for key, value in PROBTABLE:
        prob += key
        if n <= prob:
            return value
    return None

pairs = it.product(A_LIST, B_LIST)

maxprob = 0
results = dict()
for (x,y) in PROBTABLE:
    maxprob += x
    results[y] = 0

for (a,b) in pairs:
    value = tableposition( rn.randint(1, maxprob) )
    results[value] += 1
    print(WRITEFORMAT.format(a, b, value))

#print(results)

