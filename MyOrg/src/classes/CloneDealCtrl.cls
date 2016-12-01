public with sharing class CloneDealCtrl {
    public CloneDealCtrl(Apexpages.StandardController stdCon) {
    }
    
    @RemoteAction 
    public static Id cloneDeal(Id dealId) {
        String SOQL_DEAL_QUERY = 'SELECT ' + String.join(getDealFieldsToCopy(), ', ');
        SOQL_DEAL_QUERY += ' FROM Opportunity';
        SOQL_DEAL_QUERY += ' WHERE Id=\''+ dealId +'\'';
        
        Opportunity[] listDeals = (Opportunity[]) Database.Query(SOQL_DEAL_QUERY);
        listDeals[0].Id = null;
        listDeals[0].StageName = 'Planned';
        listDeals[0].Name = listDeals[0].Name + ' - ' + DateTime.now().getTime() ;
        insert listDeals;
        
        return listDeals[0].Id;
    }
    
    @RemoteAction 
    public static ProductSaveError[] cloneDealProducts(Id clonedDealId, Id[] dealProdIds) {
        
        String SOQL_DEALPROD_QUERY = 'SELECT ' + String.join(getDealProductFieldsToCopy(), ', ');
        SOQL_DEALPROD_QUERY += ' FROM OpportunityLineItem';
        SOQL_DEALPROD_QUERY += ' WHERE Id=:dealProdIds';
        
        OpportunityLineItem[] listDealProducts = (OpportunityLineItem[]) Database.Query(SOQL_DEALPROD_QUERY);
        for(OpportunityLineItem dealProd : listDealProducts) {
            dealProd.Id = null;
            dealProd.OpportunityId = clonedDealId;
        }
        
        Database.SaveResult[] prodInsertResults = Database.insert(listDealProducts, false);
        
        return getSaveErrors(prodInsertResults, listDealProducts);
    }
    
    private static ProductSaveError[] getSaveErrors(Database.SaveResult[] saveResults, OpportunityLineItem[] listDealProducts) {
        ProductSaveError[] errors = new ProductSaveError[]{};
        Map<Id,String> mapPricebookEntryError = new Map<Id,String>(); 
         
        for(Integer i=0; i< saveResults.size(); i++) {
            if(!saveResults[i].isSuccess()) {
                mapPricebookEntryError.put(listDealProducts[i].PricebookEntryId, saveResults[i].getErrors()[0].getMessage());
            }
        }
        
        system.debug('mapPricebookEntryError --> ' + mapPricebookEntryError);
        
        if(!mapPricebookEntryError.isEmpty()) {
            for(PricebookEntry pbe : [select Id, Product2.ProductCode, Product2.Name
                        from PricebookEntry where Id IN: mapPricebookEntryError.keySet() ]) {
                
                ProductSaveError err = new ProductSaveError();
                err.productCode = pbe.Product2.ProductCode;
                err.productName = pbe.Product2.Name;
                err.error = mapPricebookEntryError.get(pbe.Id);
                
                errors.add(err);
            }
        }
        
        return errors;
    }
    
    public class ProductSaveError {
        public String productCode {get;set;}
        public String productName {get;set;}
        public String error {get;set;}
    }
    
    public static String[] getDealFieldsToCopy() {
        String[] listDealFields = new String[]{};
        
        Set<String> setDealAllFields = getSObjectFields('Opportunity');
        Set<String> setDealFieldsToExclude = getFieldsToExclude('Opportunity');
        
        setDealAllFields.removeAll(setDealFieldsToExclude);
        
        listDealFields.addAll(setDealAllFields);
        System.debug('listDealFields-->'+listDealFields);
        return listDealFields;
    }
    
    
    public static String[] getDealProductFieldsToCopy() {
        String[] listDealProdFields = new String[]{};
        
        Set<String> setDealProdAllFields = getSObjectFields('OpportunityLineItem');
        Set<String> setDealProdFieldsToExclude = getFieldsToExclude('OpportunityLineItem');
        
        setDealProdAllFields.removeAll(setDealProdFieldsToExclude);
        
        listDealProdFields.addAll(setDealProdAllFields);
        System.debug('listDealProdFields-->'+listDealProdFields);
        return listDealProdFields;
    }
    
    private static Set<String> getSObjectFields(String objectName) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        Set<String> setAllFields = new Set<String>();
        
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.describeFieldResult dfield = sfield.getDescribe();
            if(!dfield.isAutoNumber() && !dfield.isCalculated() && dfield.isCreateable() ) {
                setAllFields.add(dfield.getName());
            }
        }
        
        return setAllFields;
    }
    
    private static List<Schema.FieldSetMember> getFieldsFromFieldset (String objName) {
        if(objName.equals('Opportunity'))
            return SObjectTYpe.Opportunity.FieldSets.ExcludeFieldsInClone.getFields();
        else if(objName.equals('OpportunityLineItem'))
            return SObjectTYpe.OpportunityLineItem.FieldSets.ExcludeFieldsInClone.getFields();
            
        return null;    
    }
    
    private static Set<String> getFieldsToExclude(String objectName) {
        Set<String> fieldsToExclude = new Set<String>();
        
        for (Schema.FieldSetMember field : getFieldsFromFieldset(objectName)) 
            fieldsToExclude.add(field.getFieldPath());
                
        return fieldsToExclude;
    }
}