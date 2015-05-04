/** 
Assignment Number 9
Marco Montagna
trade1 Class
This program tests adding StockTrade Elements to a Set. 
*/
import java.util.*;

public class trade1
{
	public static void main(String[] args)
	{
			//Create a new HashSet.
			Set<StockTrade> tradeSet = new HashSet<StockTrade>();
			
			
			Integer order1Number = 1;
			String order1OrderSymbol = "GOOG";
			String order1Buyer = "Joe Smith";
			String order1Seller = "Fi Securities";
			double order1NumShare = 260.00;
			double order1SharePrice = 536.12;
			long order1OrderTime1 = 1234567890;
			//Create order1 one using the above data.
			StockTrade order1 = new StockTrade(order1Number, order1OrderSymbol, order1Buyer, order1Seller, order1NumShare, order1SharePrice, order1OrderTime1);


			Integer order2Number = 2;
			String order2OrderSymbol = "CCH";
			String order2Buyer = "Bob Johnson";
			String order2Seller = "Fi Securities";
			double order2NumShare = 100.00;
			double order2SharePrice = 26.33;
			long order2OrderTime1 = 1234567890;
			//Create order2 one using the above data.
			StockTrade order2 = new StockTrade(order2Number, order2OrderSymbol, order2Buyer, order2Seller, order2NumShare, order2SharePrice, order2OrderTime1);

			Integer order3Number = 3;
			String order3OrderSymbol = "GE";
			String order3Buyer = "Eric Parke";
			String order3Seller = "Fi Securities";
			double order3NumShare = 80.00;
			double order3SharePrice = 14.26;
			long order3OrderTime1 = 1234567890;
			//Create order3 one using the above data.
			StockTrade order3 = new StockTrade(order3Number, order3OrderSymbol, order3Buyer, order3Seller, order3NumShare, order3SharePrice, order3OrderTime1);
			
			//Add each Order to the Set and print "Record successfully added." if 
			//it was successfully added and "Record Already Exists" if it fails.
			System.out.println("\nTest adding a Duplicate: \n");
			if(tradeSet.add(order1))
			{
					System.out.println("Record successfully added.");
			}
			else
			{
					System.out.println("Record already exists.");
			}
			if(tradeSet.add(order2))
			{
					System.out.println("Record successfully added.");
			}
			else
			{
					System.out.println("Record already exists.");
			}
			if(tradeSet.add(order3))
			{
					System.out.println("Record successfully added.");
			}
			else
			{
					System.out.println("Record already exists.");
			}
			if(tradeSet.add(order1))
			{
					System.out.println("Record successfully added.");
			}
			else
			{
					System.out.println("Record already exists.");
			}
			
			
			//Print the toString() data of each object in the set.
      	System.out.println("\nElement Information: \n");
      	for (StockTrade c : tradeSet)
      		System.out.println(c);
	
	
	
	
	}
	
	
	
	
	
}