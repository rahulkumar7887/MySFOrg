public without sharing class GenerateOrderController{
    public static final Integer PUBLISH_BATCH_SIZE = 50;
    
    public GenerateOrderController(ApexPages.StandardController controller) {

    }   
    
    @RemoteAction
    public static void generateOrder(Id opportunityId) {
        System.debug('#opportunityId' + opportunityId);
        Map<Id,Opportunity> mapOpportunity = getOpportunityMap(opportunityId);
        System.debug('#mapOpportunity' + mapOpportunity);
        if(!mapOpportunity.isEmpty()) {
            Opportunity opty = mapOpportunity.values().get(0);
            //If the Batch is running then it won't RUN again.
            if(!opty.Generate_Order_In_Progress__c){
                opty.Generate_Order_In_Progress__c = true;
                update opty;
                    
                // publish opty once its validated
                GenerateOrderBatch batchProcessOrders = new GenerateOrderBatch();
                batchProcessOrders.opty = opty;
                Database.executeBatch(batchProcessOrders, PUBLISH_BATCH_SIZE);
            }
            else{
                throw new CustomException('Generate Order In Progress');    
            }    
        }
    }
    
    /* HELPER METHODS */
    /*
    public static void validateAssortment(Bundle__c opty) {
        if(CRM_Functional_Permissions__c.getInstance().Revoke_Publish_Assortment__c == true ) {
            throw new CRM_CustomException(Label.CRM_PublishAssortment_Msg_InvalidAccess);
        }
        
        if(opty.Assortment_Status__c == CRM_AppConstants.ASSORTMENT_STATUS_CANCELLED) {
            throw new CRM_CustomException(Label.CRM_PublishAssortment_Msg_InvalidStatus);
        }
    }
    */
    public static Map<Id,Opportunity> getOpportunityMap(Id opportunityId) {
        Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>( [Select Id, Name, Account.Id, Pricebook2Id, OwnerId, Generate_Order_In_Progress__c,
                    (select Id, Name from OpportunityLineItems)
                    From Opportunity
                    where Id = :opportunityId ]);
        
        return mapOpportunity;
    }
    
    /**
     *  @name - createOrderRecord
     *  @Description - method to create a Order for the provided Opportunity
     *  @param - Opportunity - Opportunity used for deal creation
     *  @return - Order - Newly created Order record.
     **/     
    public static Order createOrderRecord(Opportunity opty) {
        Order ord = new Order();
        ord.UniqueKey__c = opty.Id;
        // Deal Record Type to be “High Level” if assortment has no FERTs when generating it. 
        //Update the record type to physical deal once FERTs are added.
        //ord.RecordTypeId = (hasFERTProds ? CRM_RecordTypeUtil.RT_DEAL_PHYSICAL : CRM_RecordTypeUtil.RT_DEAL_HIGH_LEVEL);
        ord.Name =  opty.Name;
        ord.Opportunity = opty;
        //String dealStage = (assortment.Assortment_Status__c == CRM_AppConstants.ASSORTMENT_STATUS_APPROVED ? CRM_AppConstants.OPPORTUNITY_STAGE_COMMITTED : CRM_AppConstants.OPPORTUNITY_STAGE_PLANNED);
        //ord.StageName = dealStage;
        ord.Status = 'Draft';
        ord.AccountId = opty.AccountId;
        ord.ContractId = '800j0000000ktxB';
        ord.EffectiveDate = System.today();
        ord.Pricebook2Id = opty.Pricebook2Id;  
        //ord.OwnerId = opty.OwnerId;
        return ord;
    }
    
    /**
     *  @name - createOrderProductRecord
     *  @Description - method to create a deal product record with information from Assortment(Bundle), Assortment_Product and Assortment_Account
     *  @param - assortment - assortment to be used for pricebook and promo/pricing dates information
     *  @param - assortmentAccount - account for which deal product will be linked
     *  @param - assortmentProduct - product to be added as deal product  
     *  @param - mapPBEntries - map of PricebookEntries to be used for linking product to a deal
     *  @return - OrderLineItem - Newly created deal product (OrderLineItem) record.
     **/
     
    public static OrderItem createOrderProductRecord(Opportunity opty, OpportunityLineItem optyli, Map<String,PricebookEntry> mapPBEntries) {
        OrderItem oli = new OrderItem();
		/*
        oli.UniquePublishKey__c = assortment.Id+'-'+assortmentAccount.Account__c+'-'+assortmentProduct.Product__c;
        
        String pbeUniqueKey = assortment.Price_Book__c +'-'+ assortmentProduct.Product__c +'-'+ assortment.CurrencyISOCode;
        oli.PricebookEntryId = mapPBEntries.get(pbeUniqueKey).Id;
        
        oli.ListPrice__c = (assortmentProduct.Assortment_Price__c != null ? assortmentProduct.Assortment_Price__c : assortmentProduct.List_Price__c) ;
        //oli.Account_Price__c = assortmentProduct.Assortment_Price__c;
        //oli.Promoted_Price__c = (oli.Account_Price__c != null ? oli.Account_Price__c : oli.ListPrice__c);
        oli.UnitPrice = assortmentProduct.List_Price__c;
        
        oli.Share__c = assortmentProduct.Share__c;
        
        Decimal totalQuantity = (assortmentAccount.Share__c != null ? assortmentAccount.Share__c : 0)  
                    * (assortmentProduct.Share__c != null ? assortmentProduct.Share__c : 0) 
                    *(assortment.High_Level_Target__c != null ? assortment.High_Level_Target__c : 0) / (100*100);
        
        totalQuantity = Math.round(totalQuantity);
        
        oli.Initial_Quantity__c = (assortment.Replen__c!= null ? Math.round(totalQuantity * (1-assortment.Replen__c/100)) : totalQuantity);
        oli.Replen_Quantity__c = (assortment.Replen__c!= null ? Math.round(totalQuantity * (assortment.Replen__c/100)) : 0) ;
        
        oli.Initial_Quantity__c = oli.Initial_Quantity__c == 0 ? 1 : oli.Initial_Quantity__c;
        oli.Published_Quantity__c = oli.Initial_Quantity__c + oli.Replen_Quantity__c;
        
        oli.Quantity = oli.Initial_Quantity__c + oli.Replen_Quantity__c;
        oli.Last_Published_Date__c = System.now();
        */
		return oli;
    }
    
        
    /**
     *  @name - getPricebookEntries
     *  @Description - method to get the PricebookEntry data so that assortment products can be linked as deal products where 
     *                  PricebookEntryId is a mandatory field to be populated
     *  @param - assortments - list of assortment for which pricebook entry records to be retrieved from system
     *  @return - Map<String,PricebookEntry> - map of PricebookEntry records with combination of "Pricebook-Product-Currency" as key
     **/
    /* 
    public static Map<String,PricebookEntry> getPricebookEntries(Bundle__c[] assortments) {
        Set<String> setCurrencyCodes = new Set<String>();
        Set<Id> setPricebookIds = new Set<Id>();
        Set<Id> setProductIds = new Set<Id>();
        
        Map<String,PricebookEntry> mapPricebookEntries = new Map<String,PricebookEntry>();
        
        for(Bundle__c  assortment : assortments) {
            setCurrencyCodes.add(assortment.CurrencyISOCode);
            setPricebookIds.add(assortment.Price_Book__c);
            
            for(Bundle_Product__c assrtProd : assortment.Bundle_Products__r) {
                setProductIds.add(assrtProd.Product__c);
            }
        }
        
        for(PricebookEntry pbe : [select Id, CurrencyISOCode, Product2Id, Product2.Name, Product2.ProductCode, Pricebook2Id  from PricebookEntry 
                where Pricebook2Id IN: setPricebookIds and Product2Id IN :setProductIds and CurrencyISOCode IN: setCurrencyCodes ]) {
            
            String mapUniqueKey = pbe.Pricebook2Id +'-'+ pbe.Product2Id +'-'+ pbe.CurrencyISOCode;
            mapPricebookEntries.put(mapUniqueKey, pbe);
        }
        
        return mapPricebookEntries;
    }
    */
    /*
    public static Map<String,Opportunity> queryPublishedDealRecords(Bundle__c assortment) {
        Map<String,Opportunity> mapPublishedDeals = new Map<String,Opportunity>(); 
        Assortment_Account__c[] listAllAssortmentAccounts = assortment.Assortment_Accounts__r;
            
        // Publish the assortment with Pricing Account Details (Create a new Deal/Deal_Products for this pricing accounts as well)
        if(assortment.Pricing_Account__c != null) {
            listAllAssortmentAccounts.add( new Assortment_Account__c(
                    Account__c = assortment.Pricing_Account__c,
                    Account__r = assortment.Pricing_Account__r,
                    Assortment__c = assortment.Id
                )
            );
        }
        
        // PREPARE LIST OF DEAL PRODUCTS TO CREATE/UPDATE 
        if(!assortment.Bundle_Products__r.isEmpty()) {
            
            for(Assortment_Account__c assrtAcc : listAllAssortmentAccounts) {
                String uniqueDealKey = assrtAcc.Assortment__c + '-' +  assrtAcc.Account__c; 
                mapPublishedDeals.put(uniqueDealKey, null);
            }
            
            for(Opportunity opp : [select Id, Bundle__c, Assortment_Account__c, Assortment_Account__r.Id, Assortment_Account__r.Account__c, Assortment_Account__r.Account_Number__c,
                    Assortment_Account__r.Share__c, TotalOpportunityQuantity, Replen__c, High_Level_Target__c, 
                    StageName, Hidden_Estimated_Quantity__c, UniquePublishKey__c, AccountId
                    from Opportunity where UniquePublishKey__c IN: mapPublishedDeals.keySet()]) {
                        
                mapPublishedDeals.put(opp.UniquePublishKey__c, opp);
            }
        }
        
        return mapPublishedDeals;
    }
    */
    /**
     *  @name - removeNonwritableFields
     *  @Description - method to remove the non-writable fields like OpportunityId and PricebookEntryId when an existing deal product is updated
     *  @param - mapOLIs - map of opportunitylineitems where key is UniquePublishKey__c
     *  @return - void
     **/
    /* 
    public static void removeNonwritableFields(Map<String,OpportunityLineItem> mapOLIs) {
        for(String oliPublishKey : mapOLIs.keySet()) {
            OpportunityLineItem lineItem = mapOLIs.get(oliPublishKey);
            
            if(lineItem.Id != null) {
                OpportunityLineItem oliToUpdate = new OpportunityLineItem(Id=lineItem.Id);
                oliToUpdate.UniquePublishKey__c = lineItem.UniquePublishKey__c;
                oliToUpdate.ListPrice__c = lineItem.ListPrice__c;
                oliToUpdate.UnitPrice = lineItem.UnitPrice;
                //oliToUpdate.Account_Price__c = lineItem.Account_Price__c;
                oliToUpdate.Promoted_Price__c = lineItem.Promoted_Price__c;
                oliToUpdate.Initial_Quantity__c = lineItem.Initial_Quantity__c;
                oliToUpdate.Replen_Quantity__c = lineItem.Replen_Quantity__c;
                oliToUpdate.Published_Quantity__c = lineItem.Published_Quantity__c;
                //oliToUpdate.Quantity = lineItem.Quantity;
                oliToUpdate.Last_Published_Date__c = lineItem.Last_Published_Date__c;
                oliToUpdate.Share__c = lineItem.Share__c;
                //Non-Writable Fields (OpportunityId and PricebookEntryId)
                //oliToUpdate.PricebookEntryId = mapPBEntries.get(pbeUniqueKey).Id;         
                
                mapOLIs.put(oliPublishKey, oliToUpdate);
            }
        }
    }
    */
    /**
     *  @name - hasFERTProducts
     *  @Description - method to find if there are any FERT products added for an assortment
     *  @param - assortmentProducts - list of assortment products pertaining to an assortment
     *  @return - void
     **/
     /*
    public static Boolean hasFERTProducts(Bundle_Product__c[] assortmentProducts) {
        Integer totalFERTCount = 0;
        
        if(assortmentProducts != null && !assortmentProducts.isEmpty()) {
            for(Bundle_Product__c ap: assortmentProducts) {
                if(ap.Product__r.SAP_Material_Type__c == AppConstants.PRODUCT_MATERIAL_TYPE_FERT) {
                    totalFERTCount++;
                }
            }
        }
        return totalFERTCount > 0 ? true : false;
    }
    */
    public static void updateOpportunity(Opportunity opty) {
        opty.Generate_Order_In_Progress__c = false;
        update opty;
    }
    
    public static void sendCompletionEmail(Opportunity opty, GenerateError[] errors) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(opty.OwnerId);
        
        List<String> ccAddresses = new List<String>{Userinfo.getUserEmail()};
        message.setccAddresses(ccAddresses);
        
        message.setSaveAsActivity(false); 
        message.subject = 'opty <'+opty.Name+'> has been published';
        
        if(errors == null || errors.isEmpty()) {
            //message.plainTextBody = 'opty has been published successfully.';
            String htmlEmailBody = '<p>opty has been published successfully.</p><p>Please find opty details:</p>';
            htmlEmailBody += createOpportunityInfoTable(opty);
            message.htmlbody = htmlEmailBody;
            
        }
        else {
            String htmlEmailBody = '<p>Please find opty details:</p>';
            htmlEmailBody += createOpportunityInfoTable(opty);
            
            htmlEmailBody += '<p>opty has been published with following error:</p>';
            htmlEmailBody += '<table style="width:90%;font-size: 15px;border: 1px solid black;border-collapse: collapse;">';
            htmlEmailBody += '  <tr>';
            htmlEmailBody += '    <th>Account Number</th>';
            htmlEmailBody += '    <th>Product Material Number</th>';
            htmlEmailBody += '    <th>POS Forecast</th>';
            htmlEmailBody += '    <th>Error Message</th>';
            htmlEmailBody += '  </tr>';
            
            for(GenerateError err :  errors) {
                htmlEmailBody += '  <tr>';
                htmlEmailBody += '    <td>'+ (String.isBlank(err.accountNumber)? '' : err.accountNumber) +'</td>';
                htmlEmailBody += '    <td>'+ (String.isBlank(err.productCode)? '' : err.productCode) +'</td>';
                htmlEmailBody += '    <td>'+ (String.isBlank(err.posForecast)? '' : err.posForecast) +'</td>';
                htmlEmailBody += '    <td>'+ (String.isBlank(err.error)? '' : err.error) +'</td>';
                htmlEmailBody += '  </tr>';
            } 
            
            htmlEmailBody += '</table>';
            message.htmlbody = htmlEmailBody;
        }
        
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
    }
    
    
    public static String createOpportunityInfoTable(Opportunity opty){
        String htmlEmailBody = '<table style="width:70%;font-size: 15px;border: 1px solid black;border-collapse: collapse;">';
               htmlEmailBody += '    <thead>';
               htmlEmailBody += '        <tr style="border: 1px solid black;border-collapse: collapse;">';
               htmlEmailBody += '            <th style="text-align: left;padding: 5px;border: 1px solid black;border-collapse: collapse;">opty Name</th>';
               htmlEmailBody += '            <th style="text-align: left;padding: 5px;border: 1px solid black;border-collapse: collapse;">Status</th>';
               htmlEmailBody += '        </tr>';
               htmlEmailBody += '    </thead>';
               htmlEmailBody += '    <tbody>';
               htmlEmailBody += '        <tr style="border: 1px solid black;border-collapse: collapse;">';
               htmlEmailBody += '            <td style=" padding: 5px;border: 1px solid black;border-collapse: collapse;"><a href="https:'+'//'+URL.getSalesforceBaseUrl().getHost()+'/'+opty.Id+'">'+opty.Name+'</a></td>';
               htmlEmailBody += '            <td style=" padding: 5px;border: 1px solid black;border-collapse: collapse;">'+opty.Status__c+'</td>';
               htmlEmailBody += '    </tbody>';
               htmlEmailBody += '</table>';
               
        return htmlEmailBody;
    }  
    
    public class GenerateError {
        public String accountNumber {get;set;}
        public String productCode {get;set;}
        public String posForecast {get;set;}
        public String error {get;set;}
    } 
}