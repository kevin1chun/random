/** 
Assignment Number 4
Marco Montagna
RandomArray Class
Generates a random array of the specified length
*/
import java.util.Random;

public class RandomArray
{
	/**
	The ReturnArray method generates and returns a 
	array of the specified length.
	@param arrayLength Specifies the length of the array.
	*/
	public static int[] ReturnArray(int arrayLength)
	{
			 int[] array = new int[arrayLength];
			 
			 Random generator = new Random();
			 int count = 0;
			 while(count < arrayLength)
			 {
			 			array[count] = generator.nextInt(100);
						count++;
						
			 }
			 return array;
	}
	
	
}