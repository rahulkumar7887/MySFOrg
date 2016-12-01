global class UpdateUserGroup implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select Id,ProfileId from user';
        return Database.getQueryLocator(query);        
    }
    global void execute(Database.BatchableContext BC, List<User> userList) {
        Map<String, String> groupMapping = new Map<String, String>();
        List<GroupMember> membersToInsert = new List<GroupMember>();
        for(Profile_Group_Mapping__c mapping: Profile_Group_Mapping__c.getAll().values()) {
            groupMapping.put(mapping.Profile_ID__c, mapping.Group_Id__c);
        }
        for(User usr: UserList) {
            String profileid = usr.profileId;
            if(groupMapping.containsKey(profileid.subString(0,15))) {
                GroupMember m = new GroupMember();
                m.userorGroupId = usr.id;
                m.groupId = groupMapping.get(profileid.subString(0,15));  
                membersToInsert.add(m);               
            }           
        }
        if(membersToInsert != null && membersToInsert.size()>0) {
            insert membersToInsert;
        }      
    }
    global void finish(Database.BatchableContext BC) {
        
    }          
}