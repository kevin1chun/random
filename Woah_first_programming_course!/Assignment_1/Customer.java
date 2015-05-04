/**
This class extends the Person class to store customer related data.
*/
public class Customer extends Person
{
	private int CustomerNumber;
	private boolean SubscribedToMailing;
	/**
	The constructor sets the customer number and the customers mailing list settings.
	@param CustomerNumberStr The  CustomerNumber of the person.
	@param SubscribedToMailingListStr The SubscribedToMailingList of the person.
	*/
	public Customer(String NameStr, String AddressStr, String TelephoneNumberStr, int CustomerNumberStr, Boolean SubscribedToMailingListStr)
	{
			super(NameStr, AddressStr, TelephoneNumberStr);
			CustomerNumber = CustomerNumberStr;
			SubscribedToMailing = SubscribedToMailingListStr;
	}
	
	/**
	The setCustomer method stores a value in the Customer field.
	@param str The value to store in Customer.
	*/
	public void setCustomer(int str)
	{
			CustomerNumber = str;
	}
	/**
	The setSubscribedToMailing method stores a value in the SubscribedToMailing field.
	@param str The value to store in SubscribedToMailing.
	*/
	public void setSubscribedToMailing(boolean str)
	{
			SubscribedToMailing = str;
	}
	/**
	The getCustomerNumber method returns a Customers object's CustomerNumber.
	@return The value in the CustomerNumber field.
	*/
	public int getCustomerNumber() 
	{
			return CustomerNumber;
	}
	/**
	The getSubscribedToMailing method returns a Customers object's SubscribedToMailing.
	@return The value in the SubscribedToMailing field.
	*/
	public boolean getSubscribedToMailing() 
	{
			return SubscribedToMailing;
	}
}