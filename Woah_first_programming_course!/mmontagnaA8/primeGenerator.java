/** 
Assignment Number 8
Marco Montagna
primeGenerator Class
This program generates a list of one hundred prime numbers 
and displays then using and iterator.
*/
import java.util.*;

public class primeGenerator 
{
	
	
	public static void main(String[] args)
	{
			ArrayList<Integer> primeList = new ArrayList<Integer>(100); //Holds the prime numbers found.
			
			//Add the first three iregular prime numbers.
			primeList.add(2); 
			primeList.add(3);
			primeList.add(5);


			int count = 0; //Store the number of prime numbers found.
			int prime = 6; //Sets prime to 6.
			int primeCheck = 1; //Initializes primeCheck.
			int divisor; //The number to divide prime by.
			int lastDigit; //Hold the final digit of each number to be tested.
			
			
			while(count < 98)
			{
					
					primeCheck = 1; //Sets primeCheck to 1 after each iteration.
					divisor = 2; //Sets the divisor to 2 after each iteration.
					int halfPrime = prime/2; //Sets halfprime to half of prime.
					
					//Finds the last digit of prime.
					lastDigit = prime; 
					while(lastDigit >= 10)
    					{
         						lastDigit = (int)lastDigit%10;
    					}
					
					
					//Prime numbers above 5 end in 1, 3, 7, or 9.
					//Checks the last digit and continues, else it stops.
					if(lastDigit == 1 || lastDigit == 3 || lastDigit == 7 || lastDigit == 9)
					{

					
					
					//Determines whether or not prime is a prime number.
					while(primeCheck != 0)
					{
							//Uses the modulus operator to determine whether or not divisor can evenly go into prime.
							primeCheck = prime % divisor;

							

							//If primeCheck == 0 then prime is not a prime number so we increment prime.
							if(primeCheck == 0)
							{
									prime++;
							}
							
							//If divisor is more than half of prime then the number is prime. 
							if(divisor >= halfPrime)
							{
									//Adds the prime number to primeList and increments prime and count 
									//to indicate a prime number has been found.
									primeList.add(prime);
									primeCheck = 0;
									count++;
									prime++;
							}
														
							divisor++; 
							
					}
					}
					else 
					{
					prime++;
					}
							

					
					
			}	
			
			//Creates and Iterator for primeList.
			ListIterator<Integer> it = primeList.listIterator();
			count = 0; //Sets count to 0.
			
			//Runs through primeList and displays the prime numbers found.
			while(it.hasNext())
			{
					System.out.println(count+" : " + it.next());
					count++;
			}
	}	
	
	
	
	
}
