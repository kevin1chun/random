/** 
Assignment Number 11
Marco Montagna
OrderStringListTest Class
This program demonstrates the OrderedStringListType class and its iterator object.
*/
import java.util.Iterator;

public class OrderListTest
{
	public static void main(String[] args)
	{
			//Create a New OrderedStringListType object.
			OrderedStringListType list = new OrderedStringListType();
			
			//Add nine objects.
			list.add("basdas");						
			list.add("csadasd");
			list.add("fasfa");
			list.add("fd");						
			list.add("sfdh");
			list.add("ty");			
			list.add("xcvb");
			list.add("xcb");
			list.add("poi");
			
			
			//Assign iteratorTest and iterator from list.
			GeneralIterator<String> iteratorTest = list.iterator();
			
			//While the list hasNext display it.
			while(iteratorTest.hasNext())
			{
					System.out.println(iteratorTest.next());
					
					
			}
			


	}
	
	
}