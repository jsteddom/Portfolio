class Solution(object):
    def kthCharacter(self, k, operations):
        #print(f"Range: {range(len(operations))}")
        word = "a"
        stringLength = 1
        for i in range(len(operations)):
            stringLength *= 2
            if len(word) >= k:
                return word[k-1]
            elif operations[i] == 1:
                word = self.kthCharacterOpZero(word)
                continue
            elif operations[i] == 0:
                #print(f"Compare k: {k} > {stringLength} String length")
                word = word + word
                #print(f"Word Dupe: {word}")
                continue
        #print(f"word: {word} and k: {k}")
        return word[k-1]



    def kthCharacterOpZero(self, word):
        for char in word:
                kVal = 0 
                numVal = ord(char)
                if numVal == 122:
                    kVal = chr(97)
                else: 
                    kVal = chr(numVal + 1)
                word = word + kVal
        #print(f"Word: {word}")
        return word  


s = Solution()
object = int(input("Enter number: "))
operations = [0,1,0,1]
result = s.kthCharacter(object, operations)
print(result)

'''

This is Leet Codes Daily challenge July 4th 2025


'''