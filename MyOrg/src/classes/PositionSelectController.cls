public with sharing class PositionSelectController {
    public List<Position__c> psList{get; set;}
    public List<Position__c> sList{get; set;}
    public Boolean ch{get;set;}
    PositionWrapper pw = new PositionWrapper();
    public PositionSelectController(){
        psList = pw.pList;
        ch = pw.pcheck;
    }
    public void selectRecords(){
        if(ch!=true)
            pw.pcheck = true;
        else
            pw.pcheck=false;
            
        ch=pw.pCheck;
        
    }
    
    public void showData(){
        sList = new List<Position__c>();
        for(Position__c p: psList){
            if(ch == true){
                sList.add(p);
            }
        }
    }
}