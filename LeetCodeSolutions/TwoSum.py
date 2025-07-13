class Solution(object):
    def twoSum(self, nums, target):
        '''
        for i in range(len(nums)):
            for j in range(len(nums)):
                if j == 0 or i == j:
                    continue
                else:
                    twoSum = nums[i] + nums[j]
                    if twoSum == target:
                        return [i, j]
        '''
        table = {}
        for i, num in enumerate(nums): # Enumerate gives index and value, so i = [0,1,2,3], num = [2, 7, 11, 15]
            print(f"Table: {table}")
            diff = target - num
            print(f"Diff: {diff}")
            if diff in table:
                return [table[diff], i]
            table[num] = i
        
            
        

s = Solution()
object = [3, 2, 4]
target = 6
result = s.twoSum(object, target) 
print(result)