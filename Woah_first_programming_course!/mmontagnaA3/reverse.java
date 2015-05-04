/** 
Assignment Number 3
Marco Montagna
Person Class
Inverts a string using recursion.
*/
public class reverse
{
	char[] arr;
	String returnstring = new String();
	int arrayLength;
	/**
	The recursiveMethod method pulls a value out of the arr[] array and add it to the 
	returnstring.	Then it calls it self again until the entire string has been inverted. 
	@param arrayLength Stores the length of the string.
	*/
	public void recursiveMethod(int arrayLength)
	{
        if (arrayLength > - 1)
        {
        returnstring = returnstring + arr[arrayLength];
			recursiveMethod(arrayLength - 1);
        }
	}
	/**
	The reversestr method accepts the string to reverse and calls the initial 
	instance of the recursiveMethod method.
	@param str accepts the string to reverse.
	*/
	public String reversestr(String str)
	{
        int arrayLength = str.length() - 1;
			arr = str.toCharArray();
        
			recursiveMethod(arrayLength);
			return returnstring;
	
	}
}