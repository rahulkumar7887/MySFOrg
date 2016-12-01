public class SchemaDescribeExample {

    Public Map<String, Schema.SObjectType> allObjMap;
    Public Map <String, Schema.SObjectField> fieldMap;
    public List<Schema.PicklistEntry> pListEnrty;
    public List<Schema.RecordTypeInfo> rTypeInfo;
    public List<Schema.ChildRelationship> childRelationship;
    
    public void SchemaDescribe(){
        //System Objects
        allObjMap = New Map<String, Schema.SObjectType>();
        allObjMap = Schema.getGlobalDescribe();
        System.debug('###### All Objects of Org#####:' + AllObjmap.keyset());
        System.debug('###### All Objects of Org#####:' + AllObjmap.values());
        //Object Fields
        String objName = 'Account';
        fieldMap = New Map <String, Schema.SObjectField>(); 
        
        Schema.DescribeSObjectResult sObjectResult = allObjMap.get(objName).getDescribe();
        
        fieldMap = sObjectResult.fields.getMap();
        System.debug('###### all fields of object## :' + fieldMap.keyset());
        
        String fieldName = 'Industry';
        Schema.DescribeFieldResult sObjectFieldResult = fieldMap.get(fieldName).getDescribe();
        
        pListEnrty = sObjectFieldResult.getPicklistValues();
        System.debug('###### all fields of object## :' + fieldMap.keyset());       
    }  
}