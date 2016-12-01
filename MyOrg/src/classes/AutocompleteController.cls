global with sharing class AutocompleteController {
    /*
    @RemoteAction
    global static list<sObject> searchObject(string objectName, string query, String numberOfResults) {

        // check if the object is a valid object to search
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(objectName);
        if (sot == null) {
            // Object name not valid
            return null;
        }       
        // create the where-clause
        String WhereClause = ' like \'%';        
        Whereclause += String.escapeSingleQuotes(query) + '%\'';
        if(objectName=='Group'){
               Whereclause += ' And type=\'Queue\' ';
        }
        if(objectName=='User'){
                //Whereclause += ' and Profile.UserLicense.LicenseDefinitionKey=\'SFDC\' and IsActive=true ';
                String UserDataObj = 'GSS_User_Data__c';
                List<GSS_ActiveUserDataProfile__c> ActiveProfileCustomSetting = GSS_ActiveUserDataProfile__c.getAll().values();
                List<String> ActiveProfile = new List<String>();
                if(ActiveProfileCustomSetting != null && !ActiveProfileCustomSetting.isEmpty()){
                    for(GSS_ActiveUserDataProfile__c prof: ActiveProfileCustomSetting){
                        ActiveProfile.add(prof.name);
                    }
                }
                system.debug('#########ActiveProfile'+ActiveProfile);
                String caseUserRecordType = Record_Type_Settings__c.getInstance('CaseUserData').Record_Type_ID__c;
                String tempWhereclause = Whereclause;
                tempWhereclause+=' and Profile__c IN:ActiveProfile and RecordTypeId =: caseUserRecordType and Active__c = 1';
                String userDataQuery = 'select id, User__r.name,User__c from ' + UserDataObj + ' where User__r.name ' + tempWhereclause;
                List<GSS_User_Data__c> userDataRecords = new List<GSS_User_Data__c>();
                set<Id> userIdSet = new Set<Id>();
                try{
                   userDataRecords = Database.query(userDataQuery);
                   if(!userDataRecords.isEmpty()){
                       for(GSS_User_Data__c usrdt: userDataRecords){
                           userIdSet.add(usrdt.User__c);
                       }
                   }
                  
                Whereclause += ' and Id IN:userIdSet ';
               }
               catch (QueryException e) { return null; }
               
        }
        if(objectName=='Product2'){
                Set<Id> productIdSet =  addPriceBookEntryList();
                Whereclause += ' and id IN:productIdSet ';
        }
        //build the dynamic soql query
        String soqlQuery = 'select id, Name from ' + objectName + ' where name' + Whereclause + ' order by Name limit ' + numberOfResults;
        
        
        List<sObject> Results = new List<sObject>();
        try {
            Results = Database.query(soqlQuery);
        }
        catch (QueryException e) { return null; }
        
        return Results;
    }
    
    global static Set<Id> addPriceBookEntryList() {
            
        List<Pricebook2> priceBookList = [Select p.Name,p.Id From Pricebook2 p where name ='GSS Support Products' ];
    
        List<PricebookEntry> priceBookEntryList =[Select p.Product2Id, p.Pricebook2Id, p.Name, p.Id From PricebookEntry p where p.Pricebook2Id =: priceBookList[0].id];
        Set<Id> productIdSet = new Set<Id>();
        for(PricebookEntry entry:priceBookEntryList){
            productIdSet.add(entry.Product2Id);
        }
        return productIdSet;
    }*/
}