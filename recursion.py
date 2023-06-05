def square(n):
    squared = n * n
    return squared



a = 3
b = square(a)
print(b)


def recursive(n):
    if n == 1:
        return 1
    else:
        print("I am at ", n)
        return n * recursive(n-1)


print(recursive(5))


def prob(attacker, defender):
    return 0.47* prob(attacker-1, defender) + prob(attacker, defender-1)