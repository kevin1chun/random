/** 
Assignment Number 3
Marco Montagna
PalindromeDetector Class
Checks whether a word or phrase is Palindrome
*/
import java.util.regex.*;

public class PalindromeDetector
{
	String StringtoCheck;
	/**
	The Check method determines whether or not a given string is a Palindrome 
	and returns true or false.
	@param InputString The string to check.
	*/
	public boolean Check(String InputString)
	{
      	StringtoCheck = InputString;
      	String patternStr = "[^a-zA-Z]";
      	String replacementStr = "";
      	
			//Creates a regular expression pattern.
      	Pattern pattern = Pattern.compile(patternStr);
      	
      	Matcher matcher = pattern.matcher(StringtoCheck);
			
			//Strips the string of any non alphabetic characters.
      	String output = matcher.replaceAll(replacementStr);
			
			//Creates a new reverse object.
      	reverse inverseString = new reverse();
			
      	//Compares the two strings.
      	if (output.equalsIgnoreCase(inverseString.reversestr(output)))
      	{
      			return true;
      	}
      	else
      	{
      			return false;
      	}
			
	
			
	}
	

}