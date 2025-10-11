import numpy as np

a = [[1, 2, 3],
     [4, 5, 6],
     [7, 8, 9]]
b = [[1, 2, 3],
     [4, 5, 6],
     [7, 8, 9]]
a = np.array(a)
b = np.array(b)


def systolic_array_sim(A=a, B=b):
    m, k = A.shape
    k2, n = B.shape
    assert k == k2
    sys_arr = np.zeros((m, n), dtype=int)
    total_steps = m+n+k-2

    for t in range(total_steps):
        print(f"\nCycle {t}")
        for i in range(m):
            for j in range(n):
                kk = t - i - j
                if 0 <= kk < k:
                    sys_arr[i, j] += A[i, kk] * B[kk, j]
        for i in range(m):
            row_str = " ".join(f"{sys_arr[i, j]:4d}" for j in range(n))
            print(f"Row {i}: {row_str}")
    print("\nFinal result:")
    print(sys_arr)
    print("\nReference (numpy):")
    print(A @ B)


if __name__ == "__main__":
    systolic_array_sim()
