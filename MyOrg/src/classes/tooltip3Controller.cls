public with sharing class tooltip3Controller {

    public String tooltip3Controller { get; set; }

    public tooltip3Controller() {

    }

    public Account myAccount{get;set;}

     public tooltip3Controller (ApexPages.StandardController stdController){
        myAccount = (Account) stdController.getRecord();
     }

}