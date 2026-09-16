def mac(a, b, acc):
    """
    Reference model for the MAC.

    result = (a * b) + acc
    """
    return (a * b) + acc


tests = [
    (5, 4, 10),
    (10, 3, 20),
    (15, 15, 5),
    (0, 100, 25),
]


print("Python MAC Reference Model")
print("--------------------------")

for a, b, acc in tests:

    expected = mac(a, b, acc)

    print(
        f"A={a:3d}  "
        f"B={b:3d}  "
        f"ACC={acc:3d}  "
        f"RESULT={expected:3d}"
    )