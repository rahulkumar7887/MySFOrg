public class SOQLInjectionDemo {
    List<Contact> queryResult;
    
    public String name {
        get { return name;}
        set { name = value;}
    }
    public PageReference query() {
        String queryName = '%' + name + '%';
        String qryString = 'SELECT Id FROM Contact WHERE Name like : queryName';
        queryResult = Database.query(qryString);
        return null;    
    }
}