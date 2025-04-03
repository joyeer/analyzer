package io.decompile.testdata;

public class Conditional {
  
  void ifStatement() {

    int number = 10;

    // checks if number is greater than 0
    if (number > 0) {
      System.out.println("The number is positive.");
    }

    System.out.println("Statement outside if block");
  }

  void ifWithString() {
      // create a string variable
      String language = "Java";

      // if statement
      if (language == "Java") {
        System.out.println("Best Programming Language");
      }
  }

  void ifElseStatement() {
      int number = 10;

      // checks if number is greater than 0
      if (number > 0) {
        System.out.println("The number is positive.");
      }
      
      // execute this block
      // if number is not greater than 0
      else {
        System.out.println("The number is not positive.");
      }

      System.out.println("Statement outside if...else block");
  }

  void ifElseIfStatement() {
      int number = 0;

      // checks if number is greater than 0
      if (number > 0) {
        System.out.println("The number is positive.");
      }

      // checks if number is less than 0
      else if (number < 0) {
        System.out.println("The number is negative.");
      }
      
      // if both condition is false
      else {
        System.out.println("The number is 0.");
      }
  }

  void nestedIfElseStatement() {
      // declaring double type variables
      Double n1 = -1.0, n2 = 4.5, n3 = -5.3, largest;

      // checks if n1 is greater than or equal to n2
      if (n1 >= n2) {

        // if...else statement inside the if block
        // checks if n1 is greater than or equal to n3
        if (n1 >= n3) {
          largest = n1;
        }

        else {
          largest = n3;
        }
      } else {

        // if..else statement inside else block
        // checks if n2 is greater than or equal to n3
        if (n2 >= n3) {
          largest = n2;
        }

        else {
          largest = n3;
        }
      }

      System.out.println("Largest Number: " + largest);
  }

  void ternary() {
    int n1 = 5, n2 = 10, max;
 
    // Largest among n1 and n2
    max = (n1 > n2) ? n1 : n2;

    // Print the largest number
    System.out.println("Maximum is = " + max);
  }
}
