package io.decompile.testdata;

class Other { static String hello = "Hello"; }
public class J2SE {
    
    void integerOperations() {
        int i = 1000000;
        System.out.println(i * i);
        long l = i;
        System.out.println(l * l);
        System.out.println(20296 / (l - i));
    }
    
    void stringLiterals() {
        String hello = "Hello", lo = "lo";
        System.out.println(hello == "Hello");
        System.out.println(Other.hello == hello);
        System.out.println(io.decompile.testdata.Other.hello == hello);
        System.out.println(hello == ("Hel"+"lo"));
        System.out.println(hello == ("Hel"+lo));
        System.out.println(hello == ("Hel"+lo).intern());
    }
    
    void arithmeticOperators() {
        // declare variables
        int a = 12, b = 5;

        // addition operator
        System.out.println("a + b = " + (a + b));

        // subtraction operator
        System.out.println("a - b = " + (a - b));

        // multiplication operator
        System.out.println("a * b = " + (a * b));

        // division operator
        System.out.println("a / b = " + (a / b));

        // modulo operator
        System.out.println("a % b = " + (a % b));
    }

    void assignmentOperators() {
        // create variables
        int a = 4;
        int var;

        // assign value using =
        var = a;
        System.out.println("var using =: " + var);

        // assign value using =+
        var += a;
        System.out.println("var using +=: " + var);

        // assign value using =*
        var *= a;
        System.out.println("var using *=: " + var);
    }
    
    void relationalOperators() {
        // create variables
        int a = 7, b = 11;

        // value of a and b
        System.out.println("a is " + a + " and b is " + b);

        // == operator
        System.out.println(a == b);  // false

        // != operator
        System.out.println(a != b);  // true

        // > operator
        System.out.println(a > b);  // false

        // < operator
        System.out.println(a < b);  // true

        // >= operator
        System.out.println(a >= b);  // false

        // <= operator
        System.out.println(a <= b);  // true
    }
    
    void logicalOperators() {
        int a = 5;
        int b = 8;
        int c = 3;
        
        // && operator
        System.out.println((a > c) && (b > a));  // true
        System.out.println((a > c) && (b < a));  // false

        // || operator
        System.out.println((a < c) || (b > a));  // true
        System.out.println((a > c) || (b < a));  // true
        System.out.println((a < c) || (b < a));  // false

        // ! operator
        System.out.println(!(a == c));  // true
        System.out.println(!(a > c));  // false
    }
    
    void logicalOperators_2() {
        int a = 5;
        int b = 8;
        int c = 3;
        int d = 9;
        // && operator
        System.out.println((a > c) && (b > a) && (c > b));
        System.out.println((a > c) || (b > a) || (c > b));
        System.out.println((a > c) || (b > a) && (c > b));
        System.out.println((a > c) && (b < a) || (c > b));
        System.out.println((a > c) && (b < a) && (c > d) || (c > b));
        System.out.println((a > c) && (b < a) || (c > d) || (c > b));
        System.out.println((a > c) && (b < a) || (c > d) && (c > b));
    }
    
    void ternaryOperator() {
        int februaryDays = 29;
        String result;

        // ternary operator
        result = (februaryDays == 28) ? "Not a leap year" : "Leap year";
        System.out.println(result);
    }

    void ternaryOperator_2() {
        int number = 3;
        int msg =  (number % 2 == 0) ? 10 : 10;
        System.out.println(msg);
    }
    
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


    
    void incrementAndDecrementOperators() {
        // declare variables
        int a = 12, b = 12;
        int result1, result2;

        // original value
        System.out.println("Value of a: " + a);

        // increment operator
        result1 = ++a;
        System.out.println("After increment: " + result1);

        System.out.println("Value of b: " + b);

        // decrement operator
        result2 = --b;
        System.out.println("After decrement: " + result2);
    }
    
    void instanceofOperator() {
        
        String str = "Programiz";
        boolean result;

        // checks if str is an instance of
        // the String class
        result = str instanceof String;
        System.out.println("Is str an object of String? " + result);
    }
    
    void spin() {
        int i;
        for (i = 0; i < 100; i++) {
            ;    // Loop body is empty
        }
    }
    
    void displayTextFiveTimes() {
        int n = 5;
        for (int i = 1; i <= n; ++i) {
            System.out.println("Java is fun");
        }
    }
    
    void displayNumberFrom1To5() {
        int n = 5;
        // for loop
        for (int i = 1; i <= n; ++i) {
          System.out.println(i);
        }
    }
    
    void whileDisplayNumber1To5() {
        // declare variables
        int i = 1, n = 5;

        // while loop from 1 to 5
        while(i <= n) {
          System.out.println(i);
          i++;
        }
    }
    
    void displaySumOfNaturalNumbers() {
        int sum = 0;
        int n = 1000;

        // for loop
        for (int i = 1; i <= n; ++i) {
          // body inside for loop
          sum += i;     // sum = sum + i
        }
           
        System.out.println("Sum = " + sum);
    }
    
    void forEachLoop() {
        // create an array
        int[] numbers = {3, 7, 5, -5};
        
        // iterating through the array
        for (int number: numbers) {
           System.out.println(number);
        }
    }
    

      
    void floatOperations() {
        // An example of overflow:
        double d = 1e308;
        System.out.print("overflow produces infinity: ");
        System.out.println(d + "*10==" + d*10);
        // An example of gradual underflow:
        d = 1e-305 * Math.PI;
        System.out.print("gradual underflow: " + d + "\n   ");
        for (int i = 0; i < 4; i++)
            System.out.print(" " + (d /= 100000));
        System.out.println();
        // An example of NaN:
        System.out.print("0.0/0.0 is Not-a-Number: ");
        d = 0.0/0.0;
        System.out.println(d);
        // An example of inexact results and rounding:
        System.out.print("inexact results with float:");
        for (int i = 0; i < 100; i++) {
            float z = 1.0f / i;
            if (z * i != 1.0f)
                System.out.print(" " + i);
        }
        System.out.println();
        // Another example of inexact results and rounding:
        System.out.print("inexact results with double:");
        for (int i = 0; i < 100; i++) {
            double z = 1.0 / i;
            if (z * i != 1.0)
                System.out.print(" " + i);
        }
        System.out.println();
        // An example of cast to integer rounding:
        System.out.print("cast to int rounds toward 0: ");
        d = 12345.6;
        System.out.println((int)d + " " + (int)(-d));
    }
    
    void dspin() {
      double i;
      for (i = 0.0; i < 100.0; i++) {
          ;    // Loop body is empty
      }
    }
    
    double doubleLocals(double d1, double d2) {
      return d1 + d2;
    }
    
    void sspin() {
      short i;
      for (i = 0; i < 100; i++) {
          ;    // Loop body is empty
      }
    }
    
    void useManyNumeric() {
      int i = 100;
      int j = 1000000;
      long l1 = 1;
      long l2 = 0xffffffff;
      double d = 2.2;
    }

    void whileInt() {
      int i = 0;
      while (i < 100) {
          i++;
      }
    }

    void whileDouble() {
      double i = 0.0;
      while (i < 100.1) {
          i++;
      }
    }

    int lessThan100(double d) {
      if (d < 100.0) {
          return 1;
      } else {
          return -1;
      }
    }

    int greaterThan100(double d) {
      if (d > 100.0) {
          return 1;
      } else {
          return -1;
      }
    }

    int addTwo(int i, int j) {
      return i + j;
    }

    static int addTwoStatic(int i, int j) {
      return i + j;
    }

    int add12and13() {
      return addTwo(12, 13);
    }

    void contineStatementInsideForLoop() {
        for (int j=0; j<=6; j++) {
            if (j==4) {
                  continue;
            }
            System.out.print(j);
        }
    }
    
    void contineStatementInsideForLoop2() {
        int i = 0;
        for (int j=0; j<=6; j++, i++) {
            if (j==4) {
                  continue;
            }
            System.out.print(j);
        }
    }
    
    void contineStatementInsideForLoop3() {
        for (int j=0; j<=6; j++) {
            if (j==4) {
                  continue;
            }
            
            if (j==5) {
                continue;
            }
            System.out.print(j);
        }
    }
    
    void breakDemo1() {
        for(int i=1; i<=10; i++){
            if(i==8) {
                break;
            }
            System.out.println(i);
        }
    }
    
    public void infiniteLoopUsingWhile() {
        while (true) {
            // do something
        }
    }
    
    public void infiniteLoopUsingFor() {
        for (;;) {
            // do something
        }
    }
    
    public void infiniteLoopUsingDoWhile() {
        do {
            // do something
        } while (true);
    }

      
    void dspin3() {
        double i = 0.0;
        try {
            double j = 1.0;
            i = i + j;
        } finally {
            double j = -1.0;
            i = i + j;
        }
    }


  
  class Near {
    int it;
    int getItNear() {
        return it;
    }
  }
  
  class Far extends Near {
    int getItFar() {
        return super.getItNear();
    }
  }

  void createBuffer() {
    int buffer[];
    int bufsz = 100;
    int value = 12;
    buffer = new int[bufsz];
    buffer[10] = value;
    value = buffer[11];
  }

  void createThreadArray() {
    Thread threads[];
    int count = 10;
    threads = new Thread[count];
    threads[0] = new Thread();
  }

  int[][][] create3DArray() {
    int grid[][][];
    grid = new int[10][5][];
    return grid;
  }

  int chooseNear(int i) {
    switch (i) {
        case 0:  return  0;
        case 1:  return  1;
        case 2:  return  2;
        default: return -1;
    }
  }

  int chooseFar(int i) {
    switch (i) {
        case -100: return -1;
        case 0:    return  0;
        case 100:  return  1;
        default:   return -1;
    }
  }

  public long nextIndex() { 
    return index++;
  }

  private long index = 0;

  void cantBeZero(int i) throws Exception {
    if (i == 0) {
        throw new Exception();
    }
  }

}
