/**
Assignment Number 6
Marco Montagna
NewOrder class
This class is a Comparator for the Collections.sort method. 
*/
import java.util.Comparator;

public class NewOrder<T extends Number>
									implements Comparator<T>
{
	/**
	The compare method compares to values and returns a integer depending on the result.
	@param object1 The first value to compare.
	@param object2 The second value to compare.
	*/
	public int compare(T object1, T object2)
	{
			//Create create two Double objects
			//and assign each object a value using the doubleValue() method from the Number class.
			Double DoubleObject1 = object1.doubleValue();
			Double DoubleObject2 = object2.doubleValue();
			
			//Compare the two values and returns relavent integer.
			if(DoubleObject1 > DoubleObject2)
			{
			return 1;
			}
			else if (DoubleObject1 < DoubleObject2)
			{
			return -1;
			}
			else
			{
			return 0;
			}
	}
	
	
}