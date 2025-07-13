'''

A hash table (hashmap/dictionary) is a key-value data structure.

Store and retrieval in constant time (average case: O(1))

'''

# Python example
hash_table = {
    "apple": 10,
    "banana": 5,
    "orange": 7
}
print(hash_table["banana"])  # Output: 5

'''
A hash function takes a key and returns an index:
index = hash(key) % size_of_array

Collisions: When two keys hash to same index
- Chaining: Store multiple values in a list at the index
- Open Addressing: Find another open spot in the array


Time complexity: 
Operation       Average Case        Worst Case
Insert          O(1)                O(n)
Lookup          O(1)                O(n)
Delete          O(1)                O(n)


Common Hash Table Use Cases
- Caching
- Fast lookup
- Removing duplicates
- Graphs (adjacency lists)

Hash Tables In Different Languages
- Python: dict
- Java: HashMap
- C++: unordered_map
- JavaScript: Object or Map

'''

# Count character frequency
def count_chars(s):
    table = {}
    for char in s:
        table[char] = table.get(char, 0) + 1
    return table

print(count_chars("hello"))
# Output: {'h': 1, 'e': 1, 'l': 2, 'o': 1}

def two_sum(nums, target):
    table = {}
    for i, num in enumerate(nums): # Enumerate gives index and value, so i = [0,1,2,3], num = [2, 7, 11, 15]
        print(f"Table: {table}")
        diff = target - num
        print(f"Diff: {diff}")
        if diff in table:
            return [table[diff], i]
        table[num] = i

print(two_sum([2, 7, 11, 15], 9))  # Output: [0, 1]
