/**
Assignment Number 1
Marco Montagna
This class is an example of how the customer and person classes can be used.
*/
public class CustomerExample
{
public static void main(String[] args)
{
Customer customer1 = new Customer("Marco", "3576 Spear Ave.", "707-825-6858", 923, false);
System.out.println(customer1.getName());
System.out.println(customer1.getAddress());
System.out.println(customer1.getTelephoneNumber());
System.out.println(customer1.getCustomerNumber() );
System.out.println(customer1.getSubscribedToMailing());
}
}