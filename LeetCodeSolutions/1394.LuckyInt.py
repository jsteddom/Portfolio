from collections import Counter

class Solution:
    def findLucky(self, arr: list[int]) -> int:
        '''
        luckyVals = -1
        i = 0
        while i < len(arr):
            print("first loop")
            currentVal = arr[i]
            count = 0
            j = 0
            while j < len(arr):
               if arr[j] == currentVal:
                   count += 1
               j = j + 1
            if count == currentVal and currentVal > luckyVals:
                luckyVals = currentVal
            i += 1
        return luckyVals
        '''
        luckyVals = -1
        valCounts = Counter(arr) # Gets count of how many times each elements appears
        # num is the element, count is frequency of element. Ex (2, 3), 2 appears 3 times
        for num, count in valCounts.items(): # .items turns valCounts from dictionary to tuples
            if num == count and num > luckyVals:
                luckyVals = num
        return luckyVals

s = Solution()
arr = [4,3,2,2,4,1,3,4,3]
print(f"Lucky Number: {s.findLucky(arr)}")
