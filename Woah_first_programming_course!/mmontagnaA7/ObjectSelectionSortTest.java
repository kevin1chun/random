/** 
Assignment Number 7
Marco Montagna
ObjectSelectionSortTest Class
This program demostrates the ObjectSelectionSortTest.
*/
public class ObjectSelectionSortTest
{
   public static void main(String[] args)
   {	 
		
		//Create 3 ComparableObjects
		ComparableObject object1 = new ComparableObject(3);
		ComparableObject object2 = new ComparableObject(1);
		ComparableObject object3 = new ComparableObject(7);
		
		//Create an array of ComparableObjects
		ComparableObject[] objects = { object1, object2, object3 };
		
      // Display the array's contents.
      System.out.println("\nOriginal order: ");
      for (ComparableObject element : objects)
         System.out.print(element.value() + " \n");
      
      // Sort the array.
      ObjectSelectionSorter.selectionSort(objects);

      // Display the array's contents.
      System.out.println("\nSorted order: ");
      for (ComparableObject element : objects)
         System.out.print(element.value() + "\n");
   }
}