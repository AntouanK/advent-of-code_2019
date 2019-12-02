import fileinput

sumOfFuel = 0

def findFuelRequirement (mass):
    return round((mass / 3)) - 2

print(findFuelRequirement(1969))
print(findFuelRequirement(100756))

for line in fileinput.input():
    mass = int(line)
    sumOfFuel += findFuelRequirement(mass)

print("___sum", sumOfFuel)
