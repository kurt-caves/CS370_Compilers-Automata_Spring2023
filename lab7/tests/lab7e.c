//  This file is more extensive on pulling out errors
// 
//  you should run your program on this file and
// when your program errors, you can remove the line 
// and run again to come across the next one

int y,Z[100];
//void y; // this should error remove after you 
//int a, b,a ;  // this should error

//int y() {}  // this should error, remove

int f(int b)
{ 

 int y;
 void z;
  //y = f();   // this should error because not parameter match
  //y = f(1, 2);   // this should error because not parameter match
  //y = f(z);   // this should error because not parameter match
  y = f ( f (1)); // Should work
  f ( f (1)); // Should work
  f ( f (1+8)); // Should work
  //f ( f (1+z)); // Should fail
 {  
 int x[10];
  x[2+3-5]=b + f(5+x[2]*b);
 }
 {  int x[10];
  x[2+3-5]=b + f(5+x[2]*b);
 }
 
} // of f()

int z;

void main(void)
{
      void z;
      int y;
       z = main(); // should work
       y = main(); // should fail
       z = main(1);  // should fail
       y = f (1);  // should work
       y = (y + 1 -2 * 3 / 4) < (5 != 6);
       y = 1 < 2;
       y = 1 <= 2;
       y = 1 > 2;
       y = 1 >= 2;
       y = 1 == 2;
       y = 1 != 2;

       z = 1 < 2; // should fail
       z = z < 2; // should fail
       z = z < z; // should work
} // of main
