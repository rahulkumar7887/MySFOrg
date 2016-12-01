public class TestUtilities {
    
  // method to create Account
  public static list<Account> createAccount(integer recSize) {
     list<Account> recs = new list<Account>();
     for(integer i=0;i<recSize;i++) {
        Account acc = new Account();
        acc.Name = 'Test Account -'+ i;
        acc.BillingStreet = '1660 International Dr';
        acc.BillingCity = 'McLean';
        acc.BillingState = 'Virginia';
        acc.BillingPostalCode = '22102';
        acc.BillingCountry = 'United States';
        recs.add(acc);
     }
     return recs;
  }
  
  // method to create case record
  public static Case createEmailToCaseRecs() {
       Case rec = new Case();
       rec.Origin = 'Email';
       rec.Reason = 'Issue: Product Usage';
       rec.SuppliedEmail = 'testuser@zenefits.com';
       rec.SuppliedName = 'Zenefits Contact';
       rec.SuppliedPhone = '3213211542';
       rec.Type = 'Tech Support';
       rec.Subject = 'Issue using the payroll system';
       rec.Status = 'New';
       rec.Priority = 'Medium';
       return rec;
  }
    
    public static List<SObject> createObjects(String sObjectType,Integer numObjects, Map<String,Object> values, Set<String> skip){
        
        // Retrieve Schema
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult dsr = gd.get(sObjectType).getDescribe();
        Map<String, SObjectField> fields = dsr.fields.getMap();
        Map<Schema.DisplayType,Object> fieldValues = fieldValueMap();
        
        // Create new objects list
        List<SObject> objects = new List<SObject>();
        objects.add(gd.get(sObjectType).newSObject());
        
        // populate origin record
        for(String key: fields.keySet()){
            Schema.DescribeFieldResult dfr = fields.get(key).getDescribe();
            if(!dfr.isUpdateable() || skip.contains(key.toLowerCase())) continue;
            if(values.containsKey(key)) objects.get(0).put(key,values.get(key));
            else objects.get(0).put(key,fieldValues.get(dfr.getType()));
        }
        
        // clone remaining records
        for(Integer objectCount = 1; objectCount < numObjects; objectCount++){
            SObject newObject = objects.get(0).clone(false,true,false,false);
            objects.add(newObject);
        }
        return objects;
    }
    
    public static Map<Schema.DisplayType,Object> fieldValueMap(){
        Map<Schema.DisplayType,Object> typeToValueMap = new Map<Schema.DisplayType,Object>();
        typeToValueMap.put(Schema.DisplayType.BOOLEAN,false);
        typeToValueMap.put(Schema.DisplayType.STRING,'');
        typeToValueMap.put(Schema.DisplayType.TEXTAREA,'');
        typeToValueMap.put(Schema.DisplayType.ENCRYPTEDSTRING,'');
        typeToValueMap.put(Schema.DisplayType.MULTIPICKLIST,'');
        typeToValueMap.put(Schema.DisplayType.PICKLIST,'');
        typeToValueMap.put(Schema.DisplayType.ADDRESS,'');
        typeToValueMap.put(Schema.DisplayType.DOUBLE,Math.random());
        typeToValueMap.put(Schema.DisplayType.PERCENT,Math.random());
        typeToValueMap.put(Schema.DisplayType.CURRENCY,Math.random());
        typeToValueMap.put(Schema.DisplayType.INTEGER,Integer.valueOf(Math.random()));
        typeToValueMap.put(Schema.DisplayType.DATE,Date.today());
        typeToValueMap.put(Schema.DisplayType.DATETIME,System.now());
        typeToValueMap.put(Schema.DisplayType.EMAIL,'test@example.com');
        typeToValueMap.put(Schema.DisplayType.PHONE,'(123) 456-7890');
        return typeToValueMap;
    }
    
    public static Map<String,Object> getUserDefaults(){
        Map<String,Object> defaults = new Map<String,Object>();
        defaults.put('emailencodingkey','UTF-8');
        defaults.put('localesidkey','en_US');
        defaults.put('country','United States');
        defaults.put('languagelocalekey','en_US');
        defaults.put('timezonesidkey','America/Los_Angeles');
        return defaults;
    }
}