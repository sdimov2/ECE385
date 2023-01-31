i = 0

with open("convertme.txt") as inputfile:
    with open("output.txt", "w") as outputfile:
        data = inputfile.read().split()
        for num in data:
            outputfile.write(f"{i}:\t\t {num};\n")
            i += 1; 

print(i)            
