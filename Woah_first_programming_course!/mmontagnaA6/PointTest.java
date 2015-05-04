/**
Assignment Number 6
Marco Montagna
MyListTest class
This program creates a PointList Object adds several point objects
and then displays their cordinate values.
*/
import javax.swing.JOptionPane;
import java.awt.Point;

public class PointTest
{
	public static void main(String[] args)
	{
			//Create a new PointList object named list.
			PointList list = new PointList();
			
			//Add three new point objects to the list array. 
			list.add(new Point(1, 2));
			list.add(new Point(3, 4));
			list.add(new Point(12, 21));
			
			//Assign each point object a value from the list array.
			Point point1 = list.queryObject(0);
			Point point2 = list.queryObject(1);
			Point point3 = list.queryObject(2);
			
			//Displays all three points cordinates. 
			JOptionPane.showMessageDialog(null, "Point 1: { " + point1.getX() + " , " + point1.getY() + " }"
			+ "\nPoint 2: { " + point2.getX() + " , " + point2.getY() + " }" 
			+ "\nPoint 3: { " + point3.getX() + " , " + point3.getY() + " }"
			);

	}
	
	
	
}