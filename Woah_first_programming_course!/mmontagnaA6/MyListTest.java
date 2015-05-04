/**
Assignment Number 6
Marco Montagna
MyListTest class
This program creates a MyList Object adds several different types of values
and then demonstrates the largest and smallest methods.  
*/
import javax.swing.JOptionPane;

public class MyListTest
{
	public static void main(String[] args)
	{
			//Create a new MyList object named list.
			MyList list = new MyList();
			
			//Add two Float objects
			list.add(new Float(5.5));
      	list.add(new Float(2.21));
			
			//Add two Double objects
      	list.add(new Double(9.9));
      	list.add(new Double(9.22));
			
			//Add two Integer objects
      	list.add(new Integer(-19));
			list.add(new Integer(3));
			
			//Display the largest value in the MyList object.
			JOptionPane.showMessageDialog(null, "Largest: " + list.largest());
			
			//Display the smallest value in the MyList object.
			JOptionPane.showMessageDialog(null, "Smallest: " + list.smallest());

			
	}
	
	
	
}