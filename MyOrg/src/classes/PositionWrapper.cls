//Example for Wrapper class
public class PositionWrapper{
    public List<Position__c> pList{get;set;}
    public Boolean pcheck{get;set;}
    public PositionWrapper(){
        pList = [select name,department__c from Position__c where status__c ='Open'];
        
    }
}