from collections import Counter

class FindSumPairs:
    def __init__(self, nums1: list[int], nums2: list[int]):
        '''
        Counter({2: 3, 3: 2, 5: 1})

        Counter looks up the frequency of each element, above
        show the 2 appears 3 times, 3 appears two times and 5 appears 1 time

        '''
        self.nums1 = nums1
        self.nums2 = nums2
        self.nums2Count = Counter(nums2)
    def add(self, index: int, val: int) -> None:
        '''
        #print(f"Before: {self.nums2[index]}")
        self.nums2[index] += val
        self.nums2Count = Counter(self.nums2)
        #print(f"After: {self.nums2[index]}")
        '''
        oldVal = self.nums2[index] # Store old value
        # This chunk deals with decermenting the counter nums2Count and updating
        # it without running Counter() again for efficient lookup
        self.nums2Count[oldVal] -= 1 
        if self.nums2Count[oldVal] == 0:
            del self.nums2Count[oldVal]

        self.nums2[index] += val # Add new value
        # This chunk gets new value at index and updates nums2Count w/o inefficient lookup
        newVal = self.nums2[index]
        self.nums2Count[newVal] += 1

    def count(self, tot: int) -> int:
        '''
        Previous solution
        i = 0
        counter = 0
        for i in self.nums1:
            for j in self.nums2:
                sum = i + j
                if sum == tot:
                    counter += 1
        return counter
        '''
        
        '''
        Previous solution
        i = 0
        j = 0
        count = self.countRecur(tot, i, j)
        return count 
        '''
        count = 0
        for i in self.nums1:
            complement = tot - i
            count += self.nums2Count.get(complement, 0)
        return count
        

    
    def countRecur(self, tot: int, i: int, j: int) -> int:
        print(f"Made it. I: {i}, J: {j}")
        if i >= len(self.nums1):
            return 0
        if j >= len(self.nums2):
            return self.countRecur(tot, i + 1, 0)
        count = 1 if self.nums1[i] + self.nums2[j] == tot else 0
        return count + self.countRecur(tot, i, j + 1)
        #return count
             
fsp = FindSumPairs([1, 1, 2, 2, 2, 3], [1, 4, 5, 2, 5, 4])

ipt = ""
while ipt != "q":
    ipt = input("Count or Add?: ")
    if ipt == "Add":
        index = int(input("Index: "))
        val = int(input("Val: "))
        fsp.add(index, val)
    if ipt == "Count":
        count = int(input("Count val: "))
        print(f"Count: {fsp.count(count)}")
