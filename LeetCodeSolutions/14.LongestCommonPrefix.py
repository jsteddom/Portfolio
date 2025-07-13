class Solution:
    def longestCommonPrefix(self, strs: list[str]) -> str:
        '''
        maxString = strs[0]
        for i in strs:
            if maxString < i:
                maxString = i
        chars = list(maxString)
        prefix = ""
        k = 0
        breaker = False
        for i in chars:
            for j in strs:
                if k >= len(j):
                    breaker = True
                    break
                if j[k] != i:
                    breaker = True
                    break
            if breaker == True:
                break
            k += 1    
            prefix += i
                
        return prefix
        '''
        if not strs:
            return ""
        
        strs.sort()
        first = strs[0]
        last = strs[-1]
        i = 0
        while i < len(first) and i < len(last) and first[i] == last[i]:
            i += 1
        return first[:i]

s = Solution()
strs = ["flower","flow","flight"]
print(f"Longest common prefix: {s.longestCommonPrefix(strs)}")