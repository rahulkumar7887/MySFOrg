public class InvocableMethodClass {
    /*
    Use the InvocableMethod annotation to identify methods that can be run as invocable actions.
    Invocable methods are called with the REST API and used to invoke a single Apex method. 
    Invocable methods have dynamic input and output values and support describe calls.
    
    Only one method in a class can have the InvocableMethod annotation.
    Triggers can’t use invocable methods.
    The invocable method must be static and public or global, and its class must be an outer class.
    Other annotations can’t be used with the InvocableMethod annotation.
    There can be at most one input parameter and its data type must be one of the following:
        A list of a primitive data type or a list of lists of a primitive data type – the generic Object type is not supported.
        A list of an sObject type or a list of lists of an sObject type – the generic sObject type is not supported.
        A list of a user-defined type, containing variables of the supported types and with the InvocableVariable annotation. Create a custom global or public Apex class to implement your data type, and make sure your class contains at least one member variable with the invocable variable annotation.
    If the return type is not Null, the data type returned by the method must be one of the following:
        A list of a primitive data type or a list of lists of a primitive data type – the generic Object type is not supported.
        A list of an sObject type or a list of lists of an sObject type – the generic sObject type is not supported.
        A list of a user-defined type, containing variables of the supported types and with the InvocableVariable annotation. Create a custom global or public Apex class to implement your data type, and make sure your class contains at least one member variable with the invocable variable annotation.
    You can use invocable methods in packages, but once you add an invocable method you can’t remove it from later versions of the package.
    An invocable method can be public in a managed package, 
    but it won’t appear as an action in the Cloud Flow Designer’s list of available actions while building or editing a flow. 
    These invocable actions can still be referred to by flows within the same managed package. 
    Global invocable methods in a managed package can be used in flows outside the managed package, anywhere in the organization, and appear in the Cloud Flow Designer’s list of available actions to add to a flow.    
    */
    
    @InvocableMethod(label='Get Account Names' description='Returns the list of account names corresponding to the specified account IDs.')
    public static List<String> getAccountNames(List<ID> ids) {
        List<String> accountNames = new List<String>();
        List<Account> accounts = [SELECT Name FROM Account WHERE Id in :ids];
        for (Account account : accounts) {
          accountNames.add(account.Name);
        }
        return accountNames;
    }
}