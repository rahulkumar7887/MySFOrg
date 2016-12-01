global without sharing class GenerateOrderBatch implements Database.Batchable<Sobject>, Database.Stateful {
    global Opportunity opty;
    // Key -> Unique Publish Key, Value --> StageName
    global Map<String,String> mapFinalDealsStageChanges = new Map<String,String>();
    global GenerateOrderController.GenerateError[] generateError = new GenerateOrderController.GenerateError[]{};
    
    public Map<String,Order> mapGeneratedOrders = new Map<String,Order>();
    public Map<String,Opportunity> mapExistingDeals = new Map<String,Opportunity>();
        
    global Opportunity[] start(Database.BatchableContext BC){
        Opportunity[] listOpportunity = [Select Id, Name, Account.Id, Pricebook2Id, OwnerId, Generate_Order_In_Progress__c From Opportunity where Id = :opty.Id];
        return listOpportunity;
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Opportunity[] listOpportunity = scope;
        
        // Create/Update a Order for every Opportunity where all Opportunity Products will be added as Order Products.
        for(Opportunity optyRec : listOpportunity) {
            //String uniqueDealKey = assrtAcc.Account__c + '-' + assrtAcc.Assortment__c;
            
            //Boolean hasFERTProducts = GenerateOrderController.hasFERTProducts(opty.Products__r);
             
            Order order = GenerateOrderController.createOrderRecord(optyRec);
            System.debug('#Order' + order);
            //order.Account = optyRec.Account;
            String uniqueDealKey = order.UniqueKey__c;
            mapGeneratedOrders.put(uniqueDealKey, order);
        }
        
        /*
        // update the Deal Record Id for published deals
        for(Opportunity opp : [select Id, TotalOpportunityQuantity, Replen__c, High_Level_Target__c, StageName, Hidden_Estimated_Quantity__c, UniquePublishKey__c 
                from Opportunity where UniquePublishKey__c IN: mapPublishedDeals.keySet()]) {
                    
            mapExistingDeals.put(opp.UniquePublishKey__c, opp);
        }
        
        // Update the stage to avoid the following issues:
        // 1) Deal cannot be created in Revised/Committed Stage
        // 2) Deal Products cannot be added on committed deals
        // and instead use two operation First insert with valid stage and then update it to committed
        for(Opportunity deal : mapPublishedDeals.values()) {
            Opportunity existingDeal = mapExistingDeals.get(deal.UniquePublishKey__c);
            Boolean isExistingDeal = existingDeal != null ? true : false;
            
            // Update the record ID and Hidden_Estimated_Quantity__c fields from existing deal record
            if(isExistingDeal) {
                deal.Id = existingDeal.Id;
                deal.Hidden_Estimated_Quantity__c = existingDeal.Hidden_Estimated_Quantity__c;
            }
            
            
            // First revise the stage of deal to add products 
            if((isExistingDeal && existingDeal.StageName == CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED)
                || (deal.StageName == CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED) ) {
                
                String changedDealStage;
                
                if(isExistingDeal == false && deal.StageName == CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED) {
                    changedDealStage = CRM_AppConstants.OPPORTUNITY_STAGE_PLANNED;
                }
                else if(isExistingDeal==true) {
                    if(existingDeal.StageName == CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED || deal.StageName == CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED) {
                        changedDealStage = CRM_AppConstants.OPPORTUNITY_STAGE_REVISED;
                        
                        if(existingDeal.StageName != CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED) {
                            changedDealStage = existingDeal.StageName;
                        }
                    } 
                } 
                
                if(changedDealStage != null) {
                    mapFinalDealsStageChanges.put(deal.UniquePublishKey__c, deal.StageName);
                    deal.StageName = changedDealStage;
                } 
            }
            

            // Default Estimated Quantity from High Level Target of an assortment 
            // Update TotalQty on opportunity Only if:
            //      1. deal is a new deal
            //      2. deal is existing but user has not overriden the Estimated Qty yet
            if(!isExistingDeal || 
                (existingDeal.TotalOpportunityQuantity == existingDeal.High_Level_Target__c)) {
                
                deal.TotalOpportunityQuantity = deal.High_Level_Target__c;
            }
        }
        */
        // create/update the Orders
        if(!mapGeneratedOrders.isEmpty()) {
            System.debug('#mapGeneratedOrders' + mapGeneratedOrders);
            Order[] ordersToUpsert = mapGeneratedOrders.values();
            Database.UpsertResult[] upsertOrderResults = Database.upsert(ordersToUpsert, false);
            logOrderUpsertErrors(ordersToUpsert, upsertOrderResults);
        }
    }
    
    
    private void logOrderUpsertErrors(Order[] generatedOrders, Database.UpsertResult[] upsertOrderResults) {
        for(Integer i=0; i < upsertOrderResults.size(); i++) {
            if(!upsertOrderResults[i].isSuccess()) {
                GenerateOrderController.GenerateError err = new GenerateOrderController.GenerateError();
                err.AccountNumber = generatedOrders[i].Account.AccountNumber;
                err.error = upsertOrderResults[i].getErrors().get(0).getMessage();
                generateError.add(err);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        /*GenerateOrderProductBatch processOrderProducts = new GenerateOrderProductBatch();
        processOrderProducts.opty = this.opty;
        //processOrderProducts.mapFinalDealsStageChanges = mapGeneratedOrders; // this.mapFinalDealsStageChanges;
        //
        processOrderProducts.generateError = this.generateError;
        Database.executeBatch(processOrderProducts, GenerateOrderController.PUBLISH_BATCH_SIZE);*/
        //order product methds.
        GenerateOrderBatchFinalActions batchPublishFinalActions = new GenerateOrderBatchFinalActions();
        batchPublishFinalActions.opty = this.opty;
        //batchPublishFinalActions.mapFinalDealsStageChanges = this.mapFinalDealsStageChanges;
        batchPublishFinalActions.generateError = this.generateError;
        Database.executeBatch(batchPublishFinalActions, GenerateOrderController.PUBLISH_BATCH_SIZE);
    }
}