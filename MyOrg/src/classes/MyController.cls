public class MyController{

    public MyController() {

    }

    public Account myAccount{get;set;}

     public MyController(ApexPages.StandardController stdController){
        myAccount = (Account)stdController.getRecord();
     }
}