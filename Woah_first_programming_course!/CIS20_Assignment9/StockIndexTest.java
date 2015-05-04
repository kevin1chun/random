/** 
Assignment Number 9
Marco Montagna
StockIndexTest Class
This program demonstrates the StockIndex class by adding and searching for stocks.
*/
public class StockIndexTest
{
	
	public static void main(String[] args)
	{	
			//Create a new StockIndex object.
			StockIndex Index1 = new StockIndex();
			
			//Create stocks "GOOG" and "JAVA".
			Stock Stock1 = new  Stock("GOOG", 536.12);
			Stock Stock2 = new  Stock("JAVA", 8.18);
			
			//Add Stocks 1 and 2 to the StockIndex Map.
			Index1.addStock(Stock1);
			Index1.addStock(Stock2);
			
			//Search for "GOOG" 
			Stock Stock3 = Index1.getStock("GOOG");
			//Print the Stock Symbol and Price per share. 
			System.out.println(Stock3.getSymbol() + " \n" + Stock3.getSharePrice() );
			System.out.println("");
			
			//Search for the symbol "AIG", Since it does not exist it returns a Stock
			//named "Not Found" which has a price per share of 0.0 . 
			Stock Stock4 = Index1.getStock("AIG");
			System.out.println(Stock4.getSymbol() + " \n" + Stock4.getSharePrice() );
			
			
	}
	
	
	
	
}