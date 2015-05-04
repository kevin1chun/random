/** 
Assignment Number 10
Marco Montagna
OrderedStringListTest Class
This program demonstrates the OrderedStringListType  class.
*/
public class OrderListTest
{
	public static void main(String[] args)
	{
			//Create a New OrderedStringListType object.
			OrderedStringListType list = new OrderedStringListType();
			
			//Demonstrate that the list is empty.
			System.out.println("isEmpty() = "+list.isEmpty());
			
			//Add two values using the add() method.
			list.add("qwe");						
			list.add("gtr");
			
			//Clear the array of the two objects we just added.
			list.clear();
			
			//Add nine more objects.
			list.add("basdas");						
			list.add("csadasd");
			list.add("fasfa");
			list.add("fd");						
			list.add("sfdh");
			list.add("ty");			
			list.add("xcvb");
			list.add("xcb");
			list.add("poi");

			//Remove a specific object.
			list.remove("basdas");
			//Remove the object at a specific index.
			list.remove(1);
			
			//Print the remaining Objects.
			System.out.println(list.get(0));
			System.out.println(list.get(1));
			System.out.println(list.get(2));
			System.out.println(list.get(3));
			System.out.println(list.get(4));
			System.out.println(list.get(5));
			System.out.println(list.get(6));
			
			//Demonstrate the indexOf() method.
		  System.out.println("indexOf(\"fd\") = " + list.indexOf("fd"));
			
			//Demonstrate the contains() method.
			System.out.println("contains(\"fd\") = " + list.contains("fd"));
			//Demonstrate the size() method.
			System.out.println("size() = " + list.size());

	}
	
	
}