class Solution:
    def isPalindrome(self, x: int) -> bool:
        fHalf = 0
        sHalf = 0
        if len(str(x)) == 1:
            return True
        elif len(str(x)) % 2 == 1:
            stringNum = str(x)
            mid = len(stringNum) // 2
            fHalf = stringNum[:mid]
            sHalf = stringNum[mid+1:]
        else:
            stringNum = str(x)
            mid = len(stringNum) // 2
            fHalf = stringNum[:mid]
            sHalf = stringNum[mid:]
        print(fHalf, sHalf)
        return fHalf == sHalf[::-1]

        
        
s = Solution()
num = int(input("Enter number: "))
print(f"Is this a palindrome? {s.isPalindrome(num)}")