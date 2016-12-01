public class RecordTypeUtil {

    public static Id RT_ACCOUNT_MARKETING {get{ return getRecordTypeId('Account-Marketing_Account');}}
    public static Id RT_Position_Technical {get{ return getRecordTypeId('Position__c-Technical_Position');}}
    public static Id RT_DEAL_B2B {get{ return getRecordTypeId('Opportunity-B2B');}}
    

    private static Map<String,Id> mapRecordTypes;

    private static Id getRecordTypeId(String objWithRectypeName){
        if(mapRecordTypes == null) {
            loadRecordTypes();
        }
        return mapRecordTypes.get(objWithRectypeName);
    }

    public static void loadRecordTypes(){
        mapRecordTypes = new Map<String,Id>();
        Set<String> setObjNames = new Set<String>{'Opportunity', 'Account', 'Product2', 'Position__c', 'Order'};

        for(RecordType rt : [select Id, Name, SobjectType, DeveloperName from RecordType where SobjectType in: setObjNames]) {
            mapRecordTypes.put(rt.SobjectType+'-'+rt.DeveloperName, rt.Id);
        }
        system.debug('mapRecordTypes-->'+mapRecordTypes);
    }
}