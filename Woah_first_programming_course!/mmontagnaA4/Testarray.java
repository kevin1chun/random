/** 
Assignment Number 4
Marco Montagna
Testarray Class
Generates four random arrays and sorts then using various methods. 
*/
public class Testarray
{
    public static void main(String[] args)
    {
	
	//Create RandomArray Objects
	RandomArray random1 = new RandomArray();
	RandomArray random2 = new RandomArray();
	RandomArray random3 = new RandomArray();
	RandomArray random4 = new RandomArray();
	
	
	//The ReturnArray method returns random twenty integer arrays.
	int[] array1 = random1.ReturnArray(20);
	int[] array2 = random2.ReturnArray(20);
	int[] array3 = random3.ReturnArray(20);
	int[] array4 = random4.ReturnArray(20);

	//Sorts the first array using Bubble Sort and returns the number of swaps.
	IntBubbleSorter selection1 = new IntBubbleSorter();
	selection1.bubbleSort(array1);
	System.out.println("BubbleSort: " + selection1.ReturnCount());
	
	//Sorts the second array using Selection Sort and returns the number of swaps.
	IntSelectionSorter selection2 = new IntSelectionSorter();
	selection2.selectionSort(array2);
	System.out.println("SelectionSort: " + selection2.ReturnCount());
	
	//Sorts the third array using Insertion Sort and returns the number of swaps.
	IntInsertionSorter selection3 = new IntInsertionSorter();
	selection3.insertionSort(array3);
	System.out.println("InsertionSort: " + selection3.ReturnCount());
	
	//Sorts the fourth array using Quick Sort and returns the number of swaps.
	IntQuickSorter selection4 = new IntQuickSorter();
	selection4.quickSort(array4);
	System.out.println("QuickSort: " + selection4.ReturnCount());
	}
}