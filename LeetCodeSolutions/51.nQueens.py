class Solution:
    def solveNQueens(self, n: int) -> list[list[str]]:
        '''
        '''
        #solutions = [["."] * n]
        nQueens = []
        print(nQueens)
        for i in range(n):
            row = ["."] * n
            row[i] = "Q"
            #nQueens.append(row)
            print(f"for loop: {nQueens}\n")
            self.deepDive(nQueens, row)
            #break
        return nQueens
    def deepDive(self, arr: list[str], row: list[str]): 
        nQueens = arr
        if not nQueens:
            nQueens.append(row)
        for i in nQueens[0]:
            row q 

        print(f"Deep dive row: {row}\n")
        #while index < size:




s = Solution()
n = int(input("Board size: "))
print(f"Solving for n-Queens: {s.solveNQueens(n)}")