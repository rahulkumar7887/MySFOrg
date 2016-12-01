public class OpportunityTriggerHandler {
    
    public static void createAsset(List<Opportunity> lstOpportunity){
        List<Asset> assetList = new List<Asset>();
        
        //Map<Id, OpportunityLineItem> mapOLI = new Map<Id, OpportunityLineItem>([SELECT Description,Id,ListPrice,Name,OpportunityId,Product2Id,PriceBookEntryId,ProductCode,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem]);
        //System.Debug('OpportunityLineItem' + mapOLI);
        
        //Set to hold Opty Id
        Set<Id> opportunityIds = new Set<Id>();
        for(Opportunity o: lstOpportunity){
            opportunityIds.add(o.Id);
        }    
        // Query for all opportunities with their related opportunity line items
        Map<Id, Opportunity> oppsWithLineItems = new Map<Id, Opportunity>([SELECT Id,Name, (SELECT Description,Id,ListPrice,Name,OpportunityId,Product2Id,Product2.Name,ProductCode,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItems) from Opportunity where Id IN :opportunityIds]);
        System.Debug('oppsWithLineItems' + oppsWithLineItems);
        
        for(Opportunity o: lstOpportunity){
            if(o.isClosed && o.isWon) {
                Asset a = new Asset();
                a.AccountId = o.AccountId;
                a.Name = o.Name;
                List<OpportunityLineItem> oliList = oppsWithLineItems.get(o.Id).OpportunityLineItems;
                System.debug('@@@' + oppsWithLineItems.get(o.Id).OpportunityLineItems);
                System.debug('@@@' + oliList);
                if(!oliList.isEmpty()) {
                    a.Product2Id = oliList[0].Product2Id;
                    a.Name = oliList[0].Product2.Name;
                }                
                assetList.add(a);
            }
        }
        insert assetList;
    }
    
    public static void preventOpptyDelete(List<Opportunity> lstOpportunity) {
        for(Opportunity Oppty: lstOpportunity) {
            if(Oppty.isClosed && Oppty.isWon) {
                Oppty.addError(Label.Opportunity_cannot_be_deleted);
            }
        }
    }
    
    public static void createNewTask(List<Opportunity> lstOpportunity){
        List<Task> lstTask = new List<Task>();
        for(Opportunity oppty: lstOpportunity){
            if(oppty.StageName == AppConstants.OPPORTUNITY_STAGE_CLOSED_WON){
                Task task = new Task();
                task.Subject = oppty.Name + 'Follow Up Task';
                task.WhatId = oppty.Id;
                lstTask.add(task);
            }
        }
        Database.insert(lstTask);
    }
}