class Solution:
    def isValid(self, s: str) -> bool:
        '''
        Originally had stack = "". 

        stack = stack + s[i] is O(k), per k operation

        stack.append(s[i]) is O(1), python lists optimized for these operations
        '''
        answer = True
        stack = []
        for i in range(len(s)):
            if s[i] == "(" or s[i] == "[" or s[i] == "{":
                stack.append(s[i])
                continue
            if not stack:
                answer = False
                break
            closer = stack[-1] + s[i]
            #print(f"\nStack: {stack}  Next char: {s[i]}")
            if closer not in ["()", "[]", "{}"]:
                #print(f"Closer: {closer}")
                answer = False
                break
            else:
                stack.pop()

        if stack:
            return False
        return answer

s = Solution()
para = "(()"
print(f"Parentheses Validity: {s.isValid(para)}")


# {[[([])]]}