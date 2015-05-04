/**
   The IntBubbleSorter class provides a public static
   method for performing a bubble sort on an int array.
*/

public class IntBubbleSorter
{

   /**
      The bubbleSort method uses the bubble sort algorithm
      to sort an int array.
      @param array The array to sort.
   */
   int count = 0; 			 // Used to count the number of swaps
   
   public void bubbleSort(int[] array)
   {
      int maxElement;  // Marks the last element to compare
      int index;       // Index of an element to compare
      int temp;        // Used to swap to elements
      
		
      // The outer loop positions maxElement at the last element
      // to compare during each pass through the array. Initially
      // maxElement is the index of the last element in the array.
      // During each iteration, it is decreased by one.
      for (maxElement = array.length - 1; maxElement >= 0; maxElement--)
      {
         // The inner loop steps through the array, comparing
         // each element with its neighbor. All of the elements
         // from index 0 thrugh maxElement are involved in the
         // comparison. If two elements are out of order, they
         // are swapped.
         for (index = 0; index <= maxElement - 1; index++)
         {
            // Compare an element with its neighbor.
            if (array[index] > array[index + 1])
            {
               // Swap the two elements.
               temp = array[index];
               array[index] = array[index + 1];
               array[index + 1] = temp;
						 count++;
            }
         }
      }
   }
   public  int ReturnCount()
   {
   return count;			
   }
}