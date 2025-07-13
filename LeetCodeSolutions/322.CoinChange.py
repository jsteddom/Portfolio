class Solution:
    def coinChange(self, coins: list[int], amount: int) -> int:
        '''
        '''
        coins.sort()
        coins.reverse()
        coinVals = [[]]
        count = 0
        for i in coins:
            
            
        

s = Solution()
coins = [5,2,1]
amount = int(input("Amount: "))
print(f"Least amount of coins for ${amount}: {s.coinChange(coins, amount)}")