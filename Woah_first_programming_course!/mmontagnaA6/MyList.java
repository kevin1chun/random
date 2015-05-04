/**
Assignment Number 6
Marco Montagna
MyList class
This class stores and arryList of the type T and provides 
methods for returning the largest and smallest values. 
*/
import java.util.ArrayList;
import java.util.Collections;
import java.util.*;


public class MyList<T extends Number>
{

	//Create a new ArrayList object named MyList.
	ArrayList MyList = new ArrayList();
	
		/**
	The add method accepts and object and adds it to the MyList array.
	@param objectAdd The object to add to the array.
	*/
	public void add(T objectAdd)
	{
			MyList.add(objectAdd);
	}
	
	/**
	The largest method sorts the MyList array and returns the largest value.
	@return The last value in the array.
	*/
	public T largest()
	{
	Collections.sort(MyList, new NewOrder());
	return (T)MyList.get(MyList.size()-1);
	}
	
	/**
	The add method accepts and object and adds it to the MyList array.
	@return The first value in the array.
	*/
	public T smallest()
	{
	Collections.sort(MyList, new NewOrder());
	return (T)MyList.get(0);
	}
	
	
	
}