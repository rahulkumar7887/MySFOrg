public with sharing class PagingController {

    public Account account {get;set;}
    List<Account> selectedList = new List<Account>();
    List<CategoryWrapper> categories {get;set;}
    PageReference pg;
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name FROM Account Order By Name limit 100]));
                // sets the number of records in each page set
                con.setPageSize(5);
            }
            return con;
        }
        set;
    }

    // returns a list of wrapper objects for the sObjects in the current page set
    public List<CategoryWrapper> getCategories(){
        categories = new List<CategoryWrapper>();
        for (Account category: (List<Account>)con.getRecords()){
            categories.add(new CategoryWrapper(category));
        }
        //System.debug('##categories' + categories);
        return categories;
    }

    // displays the selected items
     public PageReference process() {
         for(CategoryWrapper cw: categories){
         	if(cw.checked == true){
            	selectedList.add(cw.acc);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.acc.name));
            }
            else if(!cw.checked){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Please select Accounts to Process'));
         	}
         }
         System.debug('##selected##' + selectedList);
         /*
         for(CategoryWrapper cw: categories){
         	if(cw.checked){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.acc.name));
				//System.debug('Selected##' + selectedList );
            }
            else {
            	//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Please select Accounts to Process'));
         	} 
         } 
		*/         
         return null;
     }
     
     
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         for(categoryWrapper cw: categories){
             if(cw.checked == true){
                 //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.acc.name));
                 selectedList.add(cw.acc);
             }
         }
         System.debug('##selected##' + selectedList);
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }

}