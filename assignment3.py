#!/usr/bin/env python3
import argparse

def intersection(lista, listb):
    listc = []
    b = list(listb)
    for value in lista:
        if value in b:
            listc.append(value)
            b.remove(value)
    return listc

def difference(lista, listb):
    listc = []
    b = list(listb)
    for value in lista:
        if value not in b:
            listc.append(value)
        else:
            b.remove(value)
    return listc

if __name__ == "__main__":
    AP = argparse.ArgumentParser()

    AP.add_argument( "--lista", nargs = "+", type = int, required = True)
    AP.add_argument( "--listb", nargs = "+", type = int, required = True)

    # parse the command line
    args = AP.parse_args()
    # access AP options
    print("lista: %r" % args.lista)
    print("listb: %r" % args.listb)

    print("Common: %s" % intersection(args.lista, args.listb))
    print("Removed: %s" % difference(args.lista, args.listb))
    print("Added: %s" % difference(args.listb, args.lista))

# Executing result:
# ./assignment3.py --lista 5 5 6 7 7 8 9 9 9  --listb 5 6 7 9 9 9 9
# lista: [5, 5, 6, 7, 7, 8, 9, 9, 9]
# listb: [5, 6, 7, 9, 9, 9, 9]
# Common: [5, 6, 7, 9, 9, 9]
# Removed: [5, 7, 8]
# Added: [9]

