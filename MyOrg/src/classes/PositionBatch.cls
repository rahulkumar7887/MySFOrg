global class PositionBatch implements Database.Batchable<SObject>,Database.Stateful{
    Integer deptCount=0;
    Integer compCount=0;
    global Database.QueryLocator start(Database.BatchableContext bCon){
        Database.queryLocator q= Database.getQueryLocator('select department__c,min_pay__c,max_pay__c from Position__c');
        return q;
    }
    
    global void execute (Database.BatchableContext bCon,List<SObject> sList){
        for(SObject o: sList){
            Position__c p = (Position__c)o;
            if(p.department__c == null){
                p.department__c = 'Sales';
                deptCount++;
            }
            if(p.min_pay__c == null || p.max_pay__c == null){
                p.min_pay__c = 3000;
                p.max_pay__c = 6000;
                compCount++;
            }
           upsert p; 
        }

    }
    
    global void finish(Database.BatchableContext bCon){
        system.debug('No of department cleaned: '+deptCount);
        system.debug('No of compensation cleaned: '+compCount);
        
    }
}