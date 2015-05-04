/** 
Assignment Number 9
Marco Montagna
StockTrade Class
This class stores information related to a StockTrade.
*/
public class StockTrade
{
	private String OrderSymbol; // The stock symbol.
	private String Buyer; // The buyer.
	private String Seller; // The seller. 
	private Integer OrderNumber; //The order number. 
	private Double NumShare; //The number of shares being traded.
	private Double SharePrice; //The price of the shares.
	private Long OrderTime; //The time of the order.
	private String BuyerTime;  // The Buyers name plus date and time of the order.
	
	/** 
		Constructor
		@param 
	*/
	
	public StockTrade(Integer on, String os, String br, String sl, Double ns, Double sp, Long ot)
	{
			
			OrderSymbol = os;
			Buyer = br;
			Seller = sl;
			NumShare = ns;
			SharePrice = sp;
			OrderTime = ot;
			OrderNumber = on;
			BuyerTime = Buyer+OrderTime.toString();
	}
	
	/** 
		getOrderTotal
		@return the Total for the stock trade.
	*/
	
	public Double getOrderTotal()
	{
			return NumShare * SharePrice;
	}
	
	/** 
		getOrderNumber
		@return the OrderNumber for the stock trade.
	*/
	
	public Integer getOrderNumber()
	{
			return OrderNumber;
	}
	
	/** 
		getOrderSymbol
		@return The trade's stock symbold.
	*/
	
	public String getOrderSymbol()
	{
				return OrderSymbol;				
	}
	
	/** 
		getBuyer
		@return The trade's buyer.
	*/
	
	public String getBuyer()
	{
				return Buyer;				
	}

	/** 
		getSeller
		@return The trade's seller.
	*/
		
	public String getSeller()
	{
				return Seller;				
	}
	
	/** 
		getNumShare
		@return The number of shares traded.
	*/
	
	public Double getNumShare()
	{
				return NumShare;				
	}
	
	/** 
		getSharePrice
		@return The price of the traded stock.
	*/
	
	public Double getSharePrice()
	{
				return SharePrice;				
	}
	
	/** 
		getOrderTime
		@return The time the order was placed.
	*/
	
	public Long getOrderTime()
	{
				return OrderTime;				
	}
	
	/** 
		setOrderSymbol
		@param os The new value for OrderSymbol.
	*/
	
	public void setOrderSymbol(String os)
	{
				OrderSymbol = os;				
	}
	
	/** 
		setBuyer
		@param os The new value for Buyer.
	*/
	
	public void setBuyer(String br)
	{
				Buyer = br;				
	}
	
	/** 
		setSeller
		@param os The new value for Seller.
	*/
	
	public void setSeller(String sl)
	{
				Seller = sl;				
	}
	
	/** 
		setNumShare
		@param os The new value for NumShare.
	*/
	
	public void setNumShare(Double ns)
	{
				NumShare = ns;				
	}
	
	/** 
		setSharePrice
		@param os The new value for SharePrice.
	*/
	
	public void setSharePrice(Double sp)
	{
				SharePrice = sp;				
	}
	
	/** 
		setOrderTime
		@param os The new value for OrderTime.
	*/
	
	public void setOrderTime(Long ot)
	{
				OrderTime = ot;				
	}
	
	/** 
		setOrderNumber
		@param os The new value for OrderNumber.
	*/
	
	public void setOrderTime(Integer on)
	{
				OrderNumber = on;				
	}
	
	/** 
		toString
		@return A string containing basic info.
	*/
	public String toString()
	{
			return "HashCode: " + BuyerTime.hashCode()+ "\nOrder Number: " + OrderNumber + "\nStock Symbol: " + OrderSymbol + "\nOrder Total:  " + getOrderTotal();			
	}
	
	/** 
		hashCode
		@return A hash code for this object.
	*/
	public int hashCode()
	{
			return BuyerTime.hashCode();
	}
	
	/** 
		equals
		@param obj Another object to compare this object to.
		@return True if the objects are equal, otherwise false.
	*/
	
	public boolean equals(Object obj)
	{
			//Make sure the other object is a StockTrade.
			if(obj instanceof StockTrade)
			{
					//Get a StockTrade reference to obj.
					StockTrade tempTrade = (StockTrade) obj;
					
					//Compare the two Trade IDs. If the IDs are equal then they are the same order.
					if(OrderNumber == tempTrade.OrderNumber)
					{
							return true;
					}
					else
					{
							return false;
					}					
			}
			else
			{
					return false;
			}
	}
		
	
}