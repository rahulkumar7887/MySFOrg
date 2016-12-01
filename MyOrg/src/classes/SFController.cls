public with sharing class SFController {
    public List<String> objList{get;set;}
    public List<String> fldList{get;set;}
    public List<Schema.PickListEntry> fldDetails{get;set;}
    string oname;
    public void showObjects(){
        Map<String,Schema.SobjectType> sMap = schema.getGlobalDescribe();//return all the objects in the org
        objList = new List<String>(smap.keySet());
    } 
    public void showFields(){
        Map<String,Schema.sobjectType> smap = schema.getGlobalDescribe();
        oname = ApexPages.currentPage().getParameters().get('oname');
        Schema.DescribeSObjectResult sr = smap.get(oname).getDescribe();
        Map<String,Schema.SObjectField> fmap = sr.fields.getMap();
        fldList = new List<String>(fmap.keySet());
    } 
    public void showFieldDetails(){
        Map<String, SObjectType> sMap = Schema.getGlobalDescribe();
        //String oName = ApexPages.currentPage().getParameters().get('oname');
        Schema.DescribeSObjectResult orslt = sMap.get(oname).getDescribe();
        Map<String, SObjectField> fMap = orslt.fields.getMap();
        String fName = ApexPages.currentPage().getParameters().get('fname');
        Schema.DescribeFieldResult frslt = fMap.get(fName).getDescribe();
        fldDetails = frslt.getPickListValues();
        System.debug(fldDetails[0].getLabel() + ',' + fldDetails[0].getValue());
    } 
}