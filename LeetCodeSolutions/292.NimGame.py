class Solution:
    def canWinNim(self, n: int) -> bool:
        if n % 4 == 0:
            return False
        else:
            return True

s = Solution()
nim = 2
print(f"Can you win? {s.canWinNim(nim)}")