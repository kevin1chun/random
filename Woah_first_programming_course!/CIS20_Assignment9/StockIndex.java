/** 
Assignment Number 9
Marco Montagna
StockIndex Class
This class maintains an Index of Stocks.
*/
import java.util.*;

public class StockIndex
{
	//Create a HashMap with a String as t he Key and a Stock as the value.
	Map<String, Stock> StockMap = new HashMap<String, Stock>();
	
	/** 
		addSymbol
		@param  st The Stock to add to the map. 
	*/
	public void addStock(Stock st)
	{
			StockMap.put(st.getSymbol(), st);
	}
	
	/** 
		getStock
		@param  sy The symbol of the stock to return.
		@return The Stock if it exists. 
	*/
	public Stock getStock(String sy)
	{
			if(StockMap.get(sy) != null)
			{
					return StockMap.get(sy);
			}
			else
			{
					return new Stock("Not Found", 0.0);
			}
	}
	
}