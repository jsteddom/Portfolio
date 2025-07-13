class Solution(object):
    def kthCharacter(self, k):
        word = "a"
        kLoop = False
        while kLoop == False:
            for char in word: 
                numVal = ord(char)
                if numVal == 122:
                    kVal = chr(97)
                else: 
                    kVal = chr(numVal + 1)
                word = word + kVal
            length = len(word)
            if length >= k:
                print(word)
                return word[k-1]
        
'''

class Solution(object):
    def kthCharacter(self, k):
        # Create new string to be returned
        newK = k
        # Iterate over each character
        # Using ord() and chr(), convert each character to a number, add 1, convert back, then append
        for char in k: 
            numVal = ord(char)
            kVal = chr(numVal + 1)
            newK = newK + kVal

        return newK
'''        
s = Solution()
object = int(input("Enter number: "))
result = s.kthCharacter(object)
print(result)

