/** 
Person Class
Stores basic info about a person
*/
public class Person 
{
	String Name;
	String Address;
	String TelephoneNumber;
	/**
	Constructor 
	@param NameStr The Name of the person.
	@param AddressStrr The Address of the person.
	@param TelephoneNumberStr The TelephoneNumber of the person.
	*/
	public Person(String NameStr, String AddressStr, String TelephoneNumberStr)
	{
			Name = NameStr;
			Address = AddressStr;
			TelephoneNumber = TelephoneNumberStr;
	}
	
	/**
	The setName method stores a value in the Name field.
	@param str The value to store in Name.
	*/
	public void setName(String str)
	{
			Name = str;
	}
	/**
	The setAddress method stores a value in the Address field.
	@param str The value to store in Address.
	*/
	public void setAddress(String str)
	{
			Address = str;
	}
	/**
	The setTelephoneNumber method stores a value in the TelephoneNumber field.
	@param str The value to store in TelephoneNumber.
	*/
	public void setTelephoneNumber(String str)
	{
			TelephoneNumber = str;
	}
	/**
	The getName method returns a Person object's Name.
	@return The value in the Name field.
	*/
	public String getName() 
	{
			return Name;
	}
	/**
	The getAddress method returns a Person object's Address.
	@return The value in the Address field.
	*/
	public String getAddress() 
	{
			return Address;
	}
	/**
	The getTelephoneNumber method returns a Person object's TelephoneNumber.
	@return The value in the TelephoneNumber field.
	*/
	public String getTelephoneNumber() 
	{
			return TelephoneNumber;
	}
}
