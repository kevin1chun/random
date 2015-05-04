/**
Assignment Number 3
Marco Montagna
This class is an example of how the PalindromeDetector Class can be used.
*/
import javax.swing.JOptionPane;
public class PalindromeExample
{
	public static void main(String[] args)
	{
	String input;
	
	input = JOptionPane.showInputDialog("Enter a string");
	
	PalindromeDetector StringtoCheck = new PalindromeDetector();


	JOptionPane.showMessageDialog(null, StringtoCheck.Check(input));
	
	}
}