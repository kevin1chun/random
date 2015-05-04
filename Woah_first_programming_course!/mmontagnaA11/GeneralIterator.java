/** 
Assignment Number 11
Marco Montagna
GeneralIterator Class
The GeneralIterator class provides and Iterator for the GeneralList class. 
*/

import java.util.Iterator;
import java.util.NoSuchElementException;



public class GeneralIterator<E>
{
	private OrderedStringListType list; 		//The list to iterate over.
	private int previous; 					//The previous element.
	boolean canRemove;							//Flag to manage removals.
	
	
	/** Constructor
			@param aList The list to iterate over.
	*/
	public GeneralIterator(OrderedStringListType aList)
	{
			//Save the list reference.
			list = aList;
			// By setting previous to -1, we are positioning 
			//the iterator just before the first element.
			previous = -1;
			//We set the canRemove field to false. The remove
			//method can only be called after the next method
			//has been called.
			canRemove = false;
			
	}
   /** The hasNext method determines whether another
       element can be returned by a call to next.
       @return true if the iterator has more elements.
   */
   public boolean hasNext()
   {
      // The expression (previous + 1) is the index of
      // the element that will be returned from the next
      // method. If it is less than the size of the list,
      // then there is another element to return.
      if ((previous + 1) < list.size())
         return true;
      else
         return false;
   }
   
   /** The next method returns the next element in the list.
       @return The next element in the list.
   */
   public String next()
   {
      // If there are no more elements, throw an exception.
      if (!hasNext())
         throw new NoSuchElementException();
      
      // Adding one to previous gives us the index of
      // the next element in the list.
      previous++;
      
      // Set canRemove to true to indicate that the remove
      // method can be called.
      canRemove = true;
      
      // Return the list element.
      return list.get(previous);
   }
   
   /** The remove method removes from the list the last
       element that was returned by the next method.
   */
   public void remove()  
   {
      // We can only call remove after next has been called.
      if (!canRemove)
         throw new IllegalStateException();
         
      // Remove the previous element.
      list.remove(previous);
      
      // Adjust previous.
      previous--;
      
      // Reset the canRemove field. You can only call remove
      // once per call to next.
      canRemove = false;
   }
		
	
}