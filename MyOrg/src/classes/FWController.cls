//controller for Validator Page

public with sharing class FWController {
    //String oname = 'fgfhf ';
    public String msg{get;set;}
    public String oname{
        get{
            String oname = 'Universal Containers';
            return oname;
        }
    }
    
    /*public void setoname(){
        oname = 'Universal ';
         //return oname;
    }
    
    public String getoname(){
       //String oname = 'Universal ';
         return oname;
    }*/
    
    public List<Position__c> pList{
        get{
            List<Position__c> plist = [select name,department__c,status__c from Position__c];
            return pList;
        }
    }
    
    public String ename{
        get;
        set{
            String ename = value;
            if(ename==''){
                msg = 'Please input value';
            }
            else{
                msg = 'Welcome to '+ename.toUppercase();
            }
        }    
    }
    
    public void show(){
        
    }
    
}