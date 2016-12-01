public with sharing class userController2 {

    public userController2(ApexPages.StandardController controller) {
        AllObjmap = New Map<String, Schema.SObjectType>();
        AllObjmap = Schema.getGlobalDescribe();
        fieldMap = New Map <String, Schema.SObjectField>(); 
        fieldMap = AllObjmap.get('user').getDescribe().fields.getMap();
        //System.debug('All object Names :'+ AllObjmap.keyset());
        System.debug('###### all fields of object## :' + fieldMap.keyset());

    }

    
    Public Map<String, Schema.SObjectType> AllObjmap;
    Public Map <String, Schema.SObjectField> fieldMap;
    
    public List<sString> fList {set; get;}
    
    UserObject__c uObj;
   /*     
    public userController(){
        AllObjmap = New Map<String, Schema.SObjectType>();
        AllObjmap = Schema.getGlobalDescribe();
        fieldMap = New Map <String, Schema.SObjectField>(); 
        fieldMap = AllObjmap.get('user').getDescribe().fields.getMap();
        //System.debug('All object Names :'+ AllObjmap.keyset());
        System.debug('###### all fields of object## :' + fieldMap.keyset());
    }  */
    public List<sString> getfieldList(){
        System.debug('#1');
        if(fList == null) {
            System.debug('#1');
            fList = new List<sString>();
            for(string s: fieldMap.keyset()){
                System.debug(s);
                fList.add(new sString(s));
            }
        }
        return fList;   
    }
    
    public PageReference cloneUser() {
    
        List<String> selectedFields = new List<String>();
        
        for(sString s: getfieldList()) {
            if(s.isSelected == true) {
                selectedFields.add(s.str);
            }
        }        
        
        System.debug('Selected Fields...');
        for(String s: selectedFields) {
            system.debug('####' + s);
            uObj = new UserObject__c();
            uObj.Name__c = s; 
        }
        insert uObj;
        fList = null;
        return null;
    }
    
    public class sString {
        public String str {set; get;}
        public Boolean isSelected {set; get;}
        
        public sString(String s) {
            str=s;
            isSelected=false;    
        }
    }              
}