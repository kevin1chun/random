/**
Assignment Number 11
Marco Montagna
ListType class
The ListType class is a concrete generic
class for storing a list of objects.
*/

public class ListType<E> implements GeneralList<E>
{
   // Constants for the default capacity and
   // the resizing factor.
   private final int DEFAULT_CAPACITY = 10;
   private final int RESIZE_FACTOR = 2;
   
   // Private Fields
   private E[] list;       // The list
   private int elements;   // Number of elements stored
   
   /** This constructor creates an empty list of the
       default capacity.
   */
   public ListType()
   {
      // The following statement causes a compiler warning.
      // It is a necessary work-around because we cannot
      // instantiate an array of a generic type.
      list = (E[])(new Object[DEFAULT_CAPACITY]);
      elements = 0;
   }

   /** This constructor creates an empty list of the
       specified capacity.
       @param capacity The initial capacity.
       @exception IllegalArgumentException if the
       specified capacity is less than one.
   */
   public ListType(int capacity)
   {
      if (capacity < 1)
         throw new IllegalArgumentException();

      // The following statement causes a compiler warning.
      // It is a necessary work-around because we cannot
      // instantiate an array of a generic type.
      list = (E[])(new Object[capacity]);
      elements = 0;
   }
   
   /** Add an element to the end of the list.
       @param element The element to add. 
   */
   public void add(E element)
   {
      // If the list is full, resize it.
      if (elements == list.length)
         resize();
      
      // Add element to the end of the list.
      list[elements] = element;
      
      // Adjust the number of elements.
      elements++;
   }

   /** Add an element at a specific index.
       @param index The added element's position.
       @param element The element to add.
       @exception IndexOutOtBoundsException When index
                  is out of bounds.
   */   
   public void add(int index, E element)
   {
      // First make sure the index is valid.
      if (index >= elements || index < 0)
         throw new IndexOutOfBoundsException();

      // If the list is full, resize it.
      if (elements == list.length)
         resize();
         
      // Shift the elements starting at index
      // to the right one position.
      for (int index2 = elements; index2 > index; index2--)
         list[index2] = list[index2 - 1];
      
      // Add the new element at index.
      list[index] = element;
      
      // Adjust the number of elements.
      elements++;
   }
   
   /** Clear the list. */
   public void clear()
   {
      for (int index = 0; index < list.length; index++)
         list[index] = null;
      elements = 0;
   }
   
   /** Search the list for a specified element.
       @param element The element to search for.
       @return true if the list contains the element;
               false otherwise.
   */
   public boolean contains(E element)
   {
      int index = 0;          // Index counter
      boolean found = false;  // Search flag
      
      // Step through the list. When the element
      // is found, set found to true and stop.
      while (!found && index < elements)
      {
         if (list[index].equals(element))
            found = true;
         index++;
      }
      
      // Return the status of the search.
      return found;
   }
   
   /** Get an element at a specific position.
       @param index The specified index.
       @return The element at index.
       @exception IndexOutOtBoundsException When index
                  is out of bounds.
   */
   public E get(int index)
   {
      if (index >= elements || index < 0)
         throw new IndexOutOfBoundsException();
      return list[index];
   }

   /** Gets the index of the first occurrence of the
       specified element.
       @param element The element to search for.
       @return The index of the first occurrence of element
               if it exists; -1 if element is not in the list.
   */
   public int indexOf(E element)
   {
      int index = 0;          // Index counter
      boolean found = false;  // Search flag
      
      // Step through the list. When the element
      // is found, set found to true and stop.
      while (!found && index < elements)
      {
         if (list[index].equals(element))
            found = true;
         else
            index++;
      }
      
      // Return the index of element or -1.
      if (!found)
         index = -1;
      return index;
   }
   
   /** Determines whether the list is empty.
       @return true if the list is empty; false otherwise.
   */
   public boolean isEmpty()
   {
      return (elements == 0);
   }
   
   /** Remove a specific element from the list.
       @param element The element to remove.
       @return true if the element was found; false otherwise.
   */
   public boolean remove(E element)
   {
      int index = 0;          // Index counter
      boolean found = false;  // Search flag
      
      // Perform a sequential search for element. When it is
      // found, remove it and stop searching.
      while (!found && index < elements)
      {
         if (list[index].equals(element))
         {
            list[index] = null;
            found = true;
         }
         index++;
      }
      
      // If the value was found, shift all subsequent
      // elements toward the front of the list.
      if (found)
      {
         while(index < elements)
         {
            list[index - 1] = list[index];
            index++;
         }
         
         // Adjust the number of elements.
         elements--;
      }
      
      // Return the status of the search.
      return found;
   }
   
   /** Remove an element at a specific index.
       @param index The index of the element to remove.
       @return The element that was removed.
       @exception IndexOutOtBoundsException When index
                  is out of bounds.
   */ 
   public E remove(int index)
   {
      if (index >= elements || index < 0)
         throw new IndexOutOfBoundsException();

      // Save the element, but remove it from the list.
      E temp = list[index];
      list[index] = null;
      index++;

      // Shift all subsequent elements toward
      // the front of the list.
      while(index < elements)
      {
         list[index - 1] = list[index];
         index++;
      }
      
      // Adjust the number of elements.
      elements--;
      
      // Return the element that was removed.
      return temp;
   }
   
   /** Resizes the list to twice its current length. */
   private void resize()
   {
      // Calculate the new length, which is the current
      // length multiplied by the resizing factor.
      int newLength = list.length * RESIZE_FACTOR;
      
      // Create a new list.
      // Note: This statement causes a compiler warning.
      // It is a necessary work-around because we cannot
      // instantiate an array of a generic type.
      E[] tempList = (E[])(new Object[newLength]);
      
      // Copy the existing elements to the new list.
      for (int index = 0; index < elements; index++)
         tempList[index] = list[index];
      
      // Replace the existing list with the new one.
      list = tempList;
   }
  
   /** Replace the element at a specified index with
       another element.
       @param index The index of the element to replace.
       @param element The element to replace it with.
       @return The element previously stored at the index.
       @exception IndexOutOtBoundsException When index
                  is out of bounds.     
   */
   public E set(int index, E element)
   {
      if (index >= elements || index < 0)
         throw new IndexOutOfBoundsException();

      // Save the existing element at that index.
      E temp = list[index];
      
      // Replace the element with element.
      list[index] = element;
      
      // Return the previously stored element.
      return temp;
   }
   
   /** Get the number of elements in the list.
       @return The number of elements in the list.
   */
   public int size()
   {
      return elements;
   }
   
   /** Convert the list to a String array.
       @return A String array representing the the list.
   */
   public String[] toStringArray()
   {
      // Create a String array large enough to hold
      // all the elements of the list.
      String[] strArray = new String[elements];
      
      // Store each element's toString() return value
      // as an element in the String array.
      for (int index = 0; index < elements; index++)
         strArray[index] = list[index].toString();
      
      // Return the String array.
      return strArray;
   }
   
   /** Get the Capacity of the list.
   		 @return The total capacity of the list.
   */
   public int getCapacity()
   {
   		return list.length;		
   }
   
   /** Ensure that the lists capacity is atleast above a certain level.
   		 @param minCapacity the minimum capacity of the list.
   */
   public void ensureCapacity(int minCapacity)
   {
      //Extend the list capacity if it is less than minCapacity. 
		if(list.length < minCapacity) 
		{
      // Create a new list.
      E[] tempList = (E[])(new Object[minCapacity]);
      
      // Copy the existing elements to the new list.
      for (int index = 0; index < elements; index++)
         tempList[index] = list[index];
      
      // Replace the existing list with the new one.
      list = tempList;
		}
		
   }
   
   /** Trim the list so it contains no empty elements.
   */
   public void trimToSize()
   {

      // Create a new list.
      E[] tempList = (E[])(new Object[elements]);
      
      // Copy the existing elements to the new list.
      for (int index = 0; index < elements; index++)
         tempList[index] = list[index];
      
      // Replace the existing list with the new one.
      list = tempList;
		
   }
   
   
}
