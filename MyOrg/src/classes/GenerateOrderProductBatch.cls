global without sharing class GenerateOrderProductBatch implements Database.Batchable<AssortmentAccountProduct>, Database.Stateful {
    global Opportunity opty;
    global Integer MAX_PUBLISH_ERRORS = 200;
    
    // Key -> Unique Publish Key, Value --> StageName
    global Map<String,String> mapFinalDealsStageChanges;
    global GenerateOrderController.GenerateError [] generateError ;
    
    global Iterable<AssortmentAccountProduct> start(Database.BatchableContext BC){
    
        AssortmentAccountProduct[] listAssortmentAccountProduct = new AssortmentAccountProduct[]{};
        /*
        // Create a deal product for each account/product combination
        for(Bundle_Product__c assortmentProduct : assortment.Bundle_Products__r) {
            for(Assortment_Account__c assortmentAccount : assortment.Assortment_Accounts__r) {
                AssortmentAccountProduct aap = new AssortmentAccountProduct();
                aap.assortmentAccountId = assortmentAccount.Id;
                aap.assortmentProductId = assortmentProduct.Id;

                listAssortmentAccountProduct.add(aap);
            }
            
            // Publish the assortment with Pricing Account Details (Create a new Deal/Deal_Products for this pricing accounts as well)
            if(assortment.Pricing_Account__c != null && assortment.Campaign_Type__c == CRM_AppConstants.ASSORTMENT_TYPE_NATIONAL) {
                AssortmentAccountProduct aap = new AssortmentAccountProduct();
                aap.pricingAccountId = assortment.Pricing_Account__c;
                aap.assortmentProductId = assortmentProduct.Id;
    
                listAssortmentAccountProduct.add(aap);
            }
        }
        */
        
        system.debug('listAssortmentAccountProduct.size()--->'+listAssortmentAccountProduct.size());
        CustomIterable myIterable = new CustomIterable(listAssortmentAccountProduct);
        
        return myIterable;
    }
    
    /* EXECUTE METHOD */
    global void execute(Database.BatchableContext BC, List<AssortmentAccountProduct> listAssrtAccountProducts){
    /*
        system.debug('listAssrtAccountProducts size--->'+listAssrtAccountProducts.size());
        
        Map<Id,Assortment_Account__c> mapAssortmentAccounts = new Map<Id,Assortment_Account__c>(assortment.Assortment_Accounts__r);
        Map<Id,Bundle_Product__c> mapAssortmentProducts = new Map<Id,Bundle_Product__c>(assortment.Bundle_Products__r);
        
        Map<String,OpportunityLineItem> mapPublishedDealProducts = new Map<String,OpportunityLineItem>();
        Map<String,OpportunityLineItem> mapExistingDealProducts = new Map<String,OpportunityLineItem>();
        Map<Id,OpportunityLineItem> mapDealLineItemsToDelete = new Map<Id,OpportunityLineItem>();
        Map<String,Opportunity> mapPublishedDeals = CRM_PublishAssortmentHelper.queryPublishedDealRecords(assortment);
        System.debug('mapPublishedDeals size --->'+mapPublishedDeals.size());
        
        Set<Id> setProductsToPublish = getProductIdsToPublish(assortment.Bundle_Products__r);
        Map<String,PricebookEntry> mapPricebookEntries = CRM_PublishAssortmentHelper.getPricebookEntries(new Bundle__c[]{assortment});
        
        // collection to contain product corresponding to a pricebook entry 
        Map<Id,Product2> mapPricebookEntryToProduct = new Map<Id,Product2>();
        
        for(PricebookEntry pbe: mapPricebookEntries.values()) {
            mapPricebookEntryToProduct.put(pbe.Id, pbe.Product2);
        }
        
        // Create a new deal product for each of the bundle_product and link it to deal created from the assortment account
        for(AssortmentAccountProduct aap : listAssrtAccountProducts) {
            Assortment_Account__c assortmentAccount = mapAssortmentAccounts.get(aap.assortmentAccountId);
            Bundle_Product__c assortmentProduct = mapAssortmentProducts.get(aap.assortmentProductId);
            
            if(aap.pricingAccountId != null && assortment.Pricing_Account__c != null && assortment.Campaign_Type__c == CRM_AppConstants.ASSORTMENT_TYPE_NATIONAL) {
                assortmentAccount = new Assortment_Account__c(
                            Account__c = assortment.Pricing_Account__c,
                            Account__r = assortment.Pricing_Account__r,
                            Assortment__c = assortment.Id
                        );
            }
            
            
            String dealkey = assortment.Id + '-' + assortmentAccount.Account__c;
            Opportunity deal = mapPublishedDeals.get(dealkey);
            
            System.debug('AssortmentAccountProduct  --->'+aap);
            System.debug('dealkey  --->'+dealkey);
            
            if(deal != null && assortmentProduct.Product__r.SAP_Material_Type__c == CRM_AppConstants.PRODUCT_MATERIAL_TYPE_FERT ) {
                OpportunityLineItem dealProduct = CRM_PublishAssortmentHelper.createDealProductRecord(assortment, assortmentAccount, assortmentProduct, mapPricebookEntries);
                dealProduct.OpportunityId = deal.Id;
                dealProduct.Opportunity = deal;
                String uniqueDealProdKey = dealProduct.UniquePublishKey__c;
                
                mapPublishedDealProducts.put(uniqueDealProdKey, dealProduct);
            }
        }
        System.debug('mapPublishedDealProducts size --->'+mapPublishedDealProducts.size());
        // Fetch existing deal products and mark it for deletion if not added on assortment
        for(OpportunityLineItem oli : [select Id, UniquePublishKey__c, Promoted_Price__c, PricebookEntryId, PricebookEntry.Product2Id, PricebookEntry.Product2.ProductCode, 
                    Published_Quantity__c, Quantity, Initial_Quantity__c, Replen_Quantity__c, Opportunity.Assortment_Account__r.Account_Number__c
                    from OpportunityLineItem 
                    where Opportunity.UniquePublishKey__c IN: mapPublishedDeals.keySet()]) {
                        
            mapExistingDealProducts.put(oli.UniquePublishKey__c, oli);
            
            // Remove the Product if previously created from the Publish Logic but the original assortment product has been deleted
            if(oli.UniquePublishKey__c != null && !setProductsToPublish.contains(oli.PricebookEntry.Product2Id)) {
                mapDealLineItemsToDelete.put(oli.Id, oli);
            }
        }
        
        
        // Update the deal products with Deal Record Id after all the deals are inserted/updated
        for(String dealProdUniquePublishKey : mapPublishedDealProducts.keySet()) {
            OpportunityLineItem oli = mapPublishedDealProducts.get(dealProdUniquePublishKey);
            
            String dealUniquePublishKey = oli.Opportunity.Bundle__c +'-'+ oli.Opportunity.AccountId;
            Opportunity deal = mapPublishedDeals.get(dealUniquePublishKey);
            
            OpportunityLineItem existingDealProd = mapExistingDealProducts.get(dealProdUniquePublishKey);
            Boolean isExistingDealProd = mapExistingDealProducts.containsKey(dealProdUniquePublishKey) ? true : false;
            
            // Update the Id of the deal line item record from existing LineItem record
            if(isExistingDealProd) {
                oli.Id = existingDealProd.Id;
                oli.Promoted_Price__c = existingDealProd.Promoted_Price__c;
                
                Decimal totalExistingQty = existingDealProd.Quantity;
                
                //Added for Req - 378 for France - Update Initial Quantity and Replen Quantity with Existing quantities if User has entered.
                if(existingDealProd.Published_Quantity__c  != totalExistingQty){
                    oli.Initial_Quantity__c = existingDealProd.Initial_Quantity__c;
                    oli.Replen_Quantity__c = existingDealProd.Replen_Quantity__c;
                }
            }
            else {
                Bundle__c relatedAssortment = assortment;
                oli.OpportunityId = deal.Id;
        
                // Update the quantity from Hidden Estimated Quantity if available
                if(deal.Hidden_Estimated_Quantity__c != null && deal.Hidden_Estimated_Quantity__c > 0) {
                    Decimal totalQty = deal.Hidden_Estimated_Quantity__c * (oli.Share__c != null ? oli.Share__c : 0) / 100;
                    totalQty = Math.round(totalQty);
                    
                    oli.Initial_Quantity__c = (relatedAssortment.Replen__c!= null ? Math.round(totalQty * (1-relatedAssortment.Replen__c/100)) : totalQty);
                    oli.Replen_Quantity__c = (relatedAssortment.Replen__c!= null ? Math.round(totalQty * (relatedAssortment.Replen__c/100)) : 0);
                    
                    oli.Initial_Quantity__c = oli.Initial_Quantity__c == 0 ? 1 : oli.Initial_Quantity__c;
                    oli.Quantity = oli.Initial_Quantity__c + oli.Replen_Quantity__c;
                }
            }
        }
        
        
        // Delete the products which are available for deal but removed on assortment
        // Assumed that it will not be a long list of products [no need of batch processing]
        if(!mapDealLineItemsToDelete.isEmpty()) {
            Database.DeleteResult[] deleteResult;
            OpportunityLineItem[] listDealProductsToDelete;
            
            listDealProductsToDelete = mapDealLineItemsToDelete.values();
            deleteResult = Database.delete(mapDealLineItemsToDelete.values(),false);

            // Error Capturing 
            logDealProdDeleteErrors(listDealProductsToDelete, deleteResult);
        }
        
        if(!mapPublishedDealProducts.isEmpty()) {
            CRM_PublishAssortmentHelper.removeNonwritableFields(mapPublishedDealProducts);
            OpportunityLineItem[] listDealProductsToUpsert = mapPublishedDealProducts.values();
            
            //upsert listDealProductsToUpsert;
            
            Database.UpsertResult[] upsertResults = Database.upsert(listDealProductsToUpsert, false);
            
            // Error Capturing Part
            logDealProdUpsertErrors(listDealProductsToUpsert, upsertResults, mapPricebookEntryToProduct);
        }
    */
    }    
    
    /* Method to get the Product Ids of products associated to an assortment */
    /*
    private Set<Id> getProductIdsToPublish(Bundle_Product__c[] listAssortmentProducts) {
        Set<Id> setProductIds = new Set<Id>();
        
        for(Bundle_Product__c asrtProd : listAssortmentProducts) {
            setProductIds.add(asrtProd.Product__c);
        }
        
        return setProductIds;
    }
    */
    /*
    private void logDealProdDeleteErrors(OpportunityLineItem[] deletedDealProds, Database.DeleteResult[] deleteDealProdResults) {
        for(Integer i=0; i < deleteDealProdResults.size(); i++) {
            if(!deleteDealProdResults[i].isSuccess()) {
                if(publishErrors.size() > MAX_PUBLISH_ERRORS) {
                    break;
                }
                
                CRM_PublishAssortmentHelper.PublishError err = new CRM_PublishAssortmentHelper.PublishError();
                err.accountNumber = deletedDealProds[i].Opportunity.Assortment_Account__r.Account_Number__c;
                err.productCode = deletedDealProds[i].PricebookEntry.Product2.ProductCode;
                err.error = deleteDealProdResults[i].getErrors().get(0).getMessage();
                
                publishErrors.add(err);
            }
        }
    }
    
    private void logDealProdUpsertErrors(OpportunityLineItem[] publishedDealProds, Database.UpsertResult[] upsertDealProdResults,Map<Id,Product2> mapPricebookEntryToProduct) {
        for(Integer i=0; i < upsertDealProdResults.size(); i++) {
            if(!upsertDealProdResults[i].isSuccess()) {
                if(publishErrors.size() > MAX_PUBLISH_ERRORS) {
                    break;
                }
                
                CRM_PublishAssortmentHelper.PublishError err = new CRM_PublishAssortmentHelper.PublishError();
                err.accountNumber = publishedDealProds[i].Opportunity.Assortment_Account__r.Account_Number__c;
                
                if(publishedDealProds[i].PricebookEntryId != null && mapPricebookEntryToProduct.get(publishedDealProds[i].PricebookEntryId) != null) {
                    err.productCode = mapPricebookEntryToProduct.get(publishedDealProds[i].PricebookEntryId).ProductCode;
                }
                else {
                    err.productCode = 'PBEID: '+publishedDealProds[i].PricebookEntryId;
                }
                err.error = upsertDealProdResults[i].getErrors().get(0).getMessage();
                
                publishErrors.add(err);
            }
        }
    }
    */
    global void finish(Database.BatchableContext BC){
        /*
        GenerateOrderBatchFinalActions batchPublishFinalActions = new GenerateOrderBatchFinalActions();
        batchPublishFinalActions.opty = this.opty;
        batchPublishFinalActions.mapFinalDealsStageChanges = this.mapFinalDealsStageChanges;
        batchPublishFinalActions.generateError = this.generateError;
        Database.executeBatch(batchPublishFinalActions, GenerateOrderController.PUBLISH_BATCH_SIZE);
        */
    }
    
    
    global class CustomIterable implements Iterator<AssortmentAccountProduct>, Iterable<AssortmentAccountProduct> {
        AssortmentAccountProduct[] listDealProdWrapper;
        Integer counter;
        
        global CustomIterable(AssortmentAccountProduct[] listDealProdWrapper){ 
            this.listDealProdWrapper = listDealProdWrapper;
            counter = 0;
        }  
        
        global Iterator<AssortmentAccountProduct> Iterator(){
            return this;
        }
    
        global boolean hasNext(){ 
            return (counter >= listDealProdWrapper.size() ? false : true);
        }
    
        global AssortmentAccountProduct next(){
            counter++; 
            return listDealProdWrapper[counter-1];
        }
    }
    
    global class AssortmentAccountProduct {
        //global Bundle__c assortment; 
        //global Assortment_Account__c assortmentAccount;
        //global Bundle_Product__c assortmentProduct;
        global Id assortmentAccountId;
        global Id assortmentProductId;
        global Id pricingAccountId;
    }
}