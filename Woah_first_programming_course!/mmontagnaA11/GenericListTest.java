/**
Assignment Number 11
Marco Montagna
GenericListTest class
This program demonstrates the getCapacity(), ensureCapacity() 
and trimToSize() methods. 
*/
public class GenericListTest
{
	public static void main(String[] args)
	{
			//Create a new ListType object.
			ListType testList = new ListType();
			
			//Display its capacity.
			System.out.println(testList.getCapacity());
			
			//Ensure its capacity is atleast 100.
			testList.ensureCapacity(100);
			
			//Display the capacity.
			System.out.println(testList.getCapacity());

			//Trim its capacity to the total number of elements.
			testList.trimToSize();
			
			//Display the capacity. 
			System.out.println(testList.getCapacity());
	}
	
	
	
}