public with sharing class chkboxOnClick {

    public boolean temp{get;set;}
    
    public chkboxOnClick() {
        temp =false;
    }
    
    public PageReference find(){
        temp=true;
        return null;
    }
}