#include <iostream> 
using namespace std; 

int main() {
    cout << "Hello World" << endl;
    int input = 0;
    cout << "Please enter number: ";
    cin >> input;
    cout << "This is your number squared: " << (input * input) << endl;

    int myArr[] = {1,2,3,4,5}; // Declares an initialzies elements
    for (int i = 0; i < sizeof(myArr)/sizeof(myArr[0]); i++) { //the division is to get the length of array, size of returns size in bytes
        cout << myArr[i];
    }
    int mArr[5] = {0}; // Sets all values to zero
    

}