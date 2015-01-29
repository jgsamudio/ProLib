# ProLib - Library App
Prolific Interactive: *SWAG Committee*

###Implementation 

##### *Screen 1 - Initial Book List View* 
  1. Table View Controller Embedded in Navigation Controller
    * Custom Table Cell for Title and Author
    * Reloads Table on "ViewDidAppear"
    * Retrieves all information from server
      * Initialization of library object
      * Return from other views
  2. Clear Library Bar Button
    * Prompts user if there if they are sure they want to delete entire library
    * Deletes all books from library
  3. Add Book Bar Button
  4. Refresh Control for manual table refresh
  
##### *Screen 2 - Book Details*
  1. Display Book Cover Image
    * Retrieves first Google Image of the search query
    * Query: title + author + "book+cover"
  2. Displays Book Information
    * Title, Author, Publisher, Tags, Last Checked Out, Last Checked Out By
    * Information passed by singleton value
  3. Checkout Button
    * Prompt user for name
  4. Edit Button
  5. Share Book Bar Button
    * Share Text: "I'm reading [book title] by [book author]"
  
##### *Screen 3 - Add New Book*
  1. Submit Button
    * Textfields: Title, Author, Publisher, Tags
    * Checks if all fields are filled in 
    * Creates new "Book" object
    * Sends request to server to update book
  2. Done Button
    * Prompt user to dicard information if there is information in textfields
  
##### *Screen 4 - Edit Book*
  1. Update Book Information
    * Textfields: Title, Author, Publisher, Tags
    * Information passed by singleton value
  2. Delete Book
    * Removes book locally and sends request to server
  3. Done Button
    * Checks if book information changed to update book  
    * Updates textfield values 
    * Updates local object variables
    * Sends book update request to server 


    



