/**
Assignment Number 6
Marco Montagna
PointList class
This class stores and arrAyList of Points and provides a method for adding and returning objects. 
*/
import java.util.ArrayList;


public class PointList<T extends java.awt.Point>
{

	//Create a new ArrayList object named PointList.
	ArrayList PointList = new ArrayList();
	
		/**
	The add method accepts and object and adds it to the PointList array.
	@param objectAdd The object to add to the array.
	*/
	public void add(T objectAdd)
	{
			PointList.add(objectAdd);
	}
	
	/**
	The queryObject method sorts the PointList array and returns the given value.
	@param index The index of the value to be returned.
	@return The indicated value.
	*/
	public T queryObject(int index)
	{
	return (T)PointList.get(index);
	}
	

	
	
	
}