class Solution:
    def romanToInt(self, s: str) -> int:
        # Create list of chararacters in the string
        numerals = list(s)
        total = 0
        i = 0
        while i < len(numerals):
            #print(f"I at top: {i}")
            match numerals[i]:
                case "I":
                    if i + 1 < len(numerals) and numerals[i+1] == "V":
                        #print("debug")
                        total = total + 4
                        i += 2
                        #print(f"I: {i}")
                    elif i + 1 < len(numerals) and numerals[i+1] == "X":
                        total = total + 9
                        i += 2
                    else:
                        i += 1
                        total = total + 1
                case "V":
                    i += 1
                    total = total + 5
                case "X":
                    if i + 1 < len(numerals) and numerals[i+1] == "L":
                        total = total + 40
                        i += 2
                    elif i + 1 < len(numerals) and numerals[i+1] == "C":
                        total = total + 90
                        i += 2
                    else: 
                        i += 1
                        total = total + 10
                case "L":
                    i += 1
                    total = total + 50
                case "C":
                    if i + 1 < len(numerals) and numerals[i+1] == "D":
                        total = total + 400
                        i += 2
                    elif i + 1 < len(numerals) and numerals[i+1] == "M":
                        total = total + 900
                        i += 2
                    else:
                        total = total + 100
                        i += 1
                case "D":
                    total = total + 500
                    i += 1
                case "M":
                    total = total + 1000
                    i += 1
                case _:
                    print("Invalid/Base Case")
        return total
        


userInput = input("Type in numeral string: ")
s = Solution()
print(f"Value of numeral: {s.romanToInt(userInput)}")

