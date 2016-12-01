global class FutureMethodClass
{
    /*
    A future method runs in the background, asynchronously. 
    You can call a future method for executing long-running operations, 
    such as callouts to external Web services or any operation you’d like to run in its own thread, on its own time. 
    You can also make use of future methods to isolate DML operations on different sObject types to prevent the mixed DML error.
    Each future method is queued and executes when system resources become available. 
    That way, the execution of your code doesn’t have to wait for the completion of a long-running operation.
    A benefit of using future methods is that some governor limits are higher, such as SOQL query limits and heap size limits.
    */
    @future
    public static void myFutureMethod()
    {   
         // Perform some operations
    }
    /*
    Methods with the future annotation must be static methods, and can only return a void type.
    The specified parameters must be primitive data types, arrays of primitive data types, or collections of primitive data types. 
    Methods with the future annotation cannot take sObjects or objects as arguments.
        The reason why sObjects can’t be passed as arguments to future methods is because the sObject might change between the time you call the method and the time it executes. 
        In this case, the future method will get the old sObject values and might overwrite them.  
    To work with sObjects that already exist in the database, pass the sObject ID instead (or collection of IDs) and use the ID to perform a query for the most up-to-date record.    
    */    
    @future
    public static void processRecords(List<ID> recordIds)
    {   
         // Get those records based on the IDs
         List<Account> accts = [SELECT Name FROM Account WHERE Id IN :recordIds];
         // Process records
    }
    /*
    The following is a skeletal example of a future method that makes a callout to an external service. 
    Notice that the annotation takes an extra parameter (callout=true) to indicate that callouts are allowed. 
    */
    @future(callout=true)
    public static void getStockQuotes(String acctName)
    {   
         // Perform a callout to an external service
    }
}