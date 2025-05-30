# In this program, I will create a simple map navigator

# Color variables to distinguish marker
RED = "\033[31m"
RESET = "\033[0m"

def GetStartLocation(x, y):
    # Create a node that is at the starting location, node[0] will acces X and node[1] will access Y
    node = [start_X, start_Y]
    
    print("Showing start location")
    print(f"Node X: {node[0]}")
    print(f"Node Y: {node[1]}")
    print("----------------------\n\n")
    for i in range(rows):
        for j in range(cols):
            if i == node[0] and j == node[1]:
                arr[i][j] = "X"
    
    
def Navigation(map, input, node):
    if input.upper() == "UP":
        if node[0] > 0:
            arr[node[0]][node[1]] = "0"
            arr[node[0] - 1][node[1]] = "X"
            node[0] = node[0] - 1
            return node
        else:
            print("--------------------\n")
            print("INVALID MOVEMENT")
            print("\n--------------------\n")
            return node
        
    if input.upper() == "DOWN":
        if node[0] < rows - 1:
            arr[node[0]][node[1]] = "0"
            arr[node[0] + 1][node[1]]= "X"
            node[0] = node[0] + 1
            return node
        else:
            print("--------------------\n")
            print("INVALID MOVEMENT")
            print("\n--------------------\n")
            return node
        
    if input.upper() == 'LEFT':
        if node[1] >= 0:
            arr[node[0]][node[1]] = "0"
            arr[node[0]][node[1] - 1] = "X"
            node[1] = node[1] - 1
            return node
        else:
            print("--------------------\n")
            print("INVALID MOVEMENT")
            print("\n--------------------\n")
            return node
        
    if input.upper() == 'RIGHT':
        if node[1] < cols - 1:
            arr[node[0]][node[1]] = "0"
            arr[node[0]][node[1] + 1] = "X"
            node[1] = node[1] + 1
            return node
        else:
            print("--------------------\n")
            print("INVALID MOVEMENT")
            print("\n--------------------\n")
            return node
    else: 
        print("--------------------\n")
        print("INVALID COMMAND")
        print("\n--------------------\n")
        return node
def DisplayMap(map):
    # Print array
    for i in range(rows):
        for j in range(cols):
            if arr[i][j] == 'X':
                print(RED + arr[i][j] + RESET, end=" ")
            else:
                print(arr[i][j], end=" ") 
        print("\n")
    print("--------------------")
    return



# Declare size of maze (which is a some rectangle)
rows, cols = (7, 7)
# Declare array
arr = [[0 for i in range(cols)] for j in range(rows)] 
# Print array
DisplayMap(arr)
# Get starting position from user
start_X = int(input("Select X: "))
start_Y = int(input("Select Y: "))
# Mark starting location
GetStartLocation(start_X, start_Y)
node = [start_X, start_Y]

while True:
    # Display Location
    DisplayMap(arr)
    # Get user input
    inputDirection = input("Move UP, DOWN, LEFT, RIGHT, or you may QUIT:   ")
    # If input is to QUIT, exit
    if inputDirection.upper() == "QUIT":
        break
    # Navigate map
    node = Navigation(arr, inputDirection, node)
    





