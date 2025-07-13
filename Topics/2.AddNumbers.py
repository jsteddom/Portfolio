# Definition for singly-linked list.
class ListNode(object):
     def __init__(self, val=0, next=None):
         self.val = val
         self.next = next
class Solution(object):
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: Optional[ListNode]
        :type l2: Optional[ListNode]
        :rtype: Optional[ListNode]
        """
        #return self.recursion(l1,l2)
        total = self.recursion(l1,l2)
        total_List = [int(num) for num in str(total)]
        # Create the linked list
        dummy = ListNode()  # dummy head node
        current = dummy

        for digit in reversed(total_List):
            current.next = ListNode(digit)
            current = current.next

        return dummy.next  # skip the dummy and get the real head

    def recursion(self, l1, l2):
        if l1 is not None and l2 is not None and l1.next is not None and l2.next is not None:
            #print("Recursion")
            #print(f"l1: {l1.val} l2: {l2.val}")
            return (10 * self.recursion(l1.next, l2.next)) + l1.val + l2.val
        elif l1 is not None and l1.next is not None and l2 is not None:
            #print("Only L1")
            #l2.val = 0
            lTwo = l2.val
            l2.val = 0
            #print(f"l1: {l1.val} l2: {l2.val}")
            return (10 * self.recursion(l1.next, l2)) + l1.val +lTwo
        elif l2 is not None and l2.next is not None and l1 is not None:
            #print("Only L2")
            #l1.val = 0
            lOne = l1.val
            l1.val = 0
            #print(f"l1: {l1.val} l2: {l2.val}")
            return (10 * self.recursion(l1, l2.next)) + l2.val + lOne

        
        #print(f"Ending, l1: {l1.val} l2: {l2.val}")
        return l1.val + l2.val
        #print(l1.next.val)

        


l1 = ListNode(2)
l1.next = ListNode(4)
l1.next.next = ListNode(3)
l2 = ListNode(5)
l2.next = ListNode(6)
l2.next.next = ListNode(4)

s = Solution()
print(f"Adding linked lists: {s.addTwoNumbers(l1,l2)}")




'''

This solution gets the correct total, but does not create a linked list
while in recursion. 

 def addTwoNumbers(self, l1, l2):
        """
        :type l1: Optional[ListNode]
        :type l2: Optional[ListNode]
        :rtype: Optional[ListNode]
        """
        #return self.recursion(l1,l2)
        total = self.recursion(l1,l2)
        total_List = [int(num) for num in str(total)]
        # Create the linked list
        dummy = ListNode()  # dummy head node
        current = dummy

        for digit in reversed(total_List):
            current.next = ListNode(digit)
            current = current.next

        return dummy.next  # skip the dummy and get the real head

    def recursion(self, l1, l2):
        if l1 is not None and l2 is not None and l1.next is not None and l2.next is not None:
            #print("Recursion")
            #print(f"l1: {l1.val} l2: {l2.val}")
            return (10 * self.recursion(l1.next, l2.next)) + l1.val + l2.val
        elif l1 is not None and l1.next is not None and l2 is not None:
            #print("Only L1")
            #l2.val = 0
            lTwo = l2.val
            l2.val = 0
            #print(f"l1: {l1.val} l2: {l2.val}")
            return (10 * self.recursion(l1.next, l2)) + l1.val +lTwo
        elif l2 is not None and l2.next is not None and l1 is not None:
            #print("Only L2")
            #l1.val = 0
            lOne = l1.val
            l1.val = 0
            #print(f"l1: {l1.val} l2: {l2.val}")
            return (10 * self.recursion(l1, l2.next)) + l2.val + lOne

        
        #print(f"Ending, l1: {l1.val} l2: {l2.val}")
        return l1.val + l2.val
        #print(l1.next.val)



'''