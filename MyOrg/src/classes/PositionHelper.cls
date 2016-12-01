public with sharing virtual class PositionHelper extends UCmodel{
    public override virtual void calcTax(Position__c p){
        Double avgPay = (p.min_pay__c+p.max_pay__c)/2;
        Double tax = avgPay*0.25;
        system.debug('tax payable is '+ tax);
    }
    
    public void checkPay(Position__c p){
        if(p.min_pay__c < p.max_pay__c){
            system.debug('Data valid...');
        }
        else{
            throw new PositionException('Invalid data in compensation',p);
        }
    }
    
    public static void checkCompensation(List<Position__c> pList,Map<id,Position__c> pMap){
        for(Position__c p: pList){
            if(p.min_pay__c < pmap.get(p.id).min_pay__c){
                p.min_pay__c.addError('Cannot provide lesser minpay');
            }
            
            if(p.max_pay__c < pmap.get(p.id).max_pay__c){
                p.max_pay__c.addError('Cannot provide lesser maxpay');
            }
        }
    }
    public static void createAutomatedChatter(List<Position__c> pList){
        List<EntitySubscription> esList = new List<EntitySubscription>();
        for(Position__c p:pList){
            EntitySubscription es = new EntitySubscription();
            es.parentId = p.id;
            es.subscriberId = p.Hiring_manager__c;
            esList.add(es);
        }
        
        insert esList;
    }
    
    public static void shareRecord(List<Position__c> pList){
        List<Position__share> srList = new List<Position__share>();
        for(Position__c p:pList){
            if(p.Hiring_Manager__c<>null){
                Position__share ps = new Position__share();
                ps.ParentId = p.id;
                ps.UserorGroupId = p.Hiring_Manager__c;
                ps.Accesslevel = 'Edit';
                ps.rowcause = schema.position__share.rowcause.Consultant__c;
                
                srList.add(ps);
            }
        }
        Database.insert(srList,false);
    }
    //when position status become open, send notification to full organisation.for that create a group in chatter(EmployeeReferer) and add members
    public static void sendChatterNote(List<Position__c> pList ){
        List<FeedItem> fList = new List<FeedItem>();
        CollaborationGroup cg = [select id from CollaborationGroup where name = 'EmployeeReferer'];
        for(Position__c p:pList){
            if(p.status__c.equals('Open') && p.sub_status__c.equals('Approved')){
                FeedItem fi = new FeedItem();
                fi.title = 'Position Alert..';
                fi.body = 'Please refer candidates for Open Position';
                fi.linkUrl = '/'+p.id;
                fi.parentId = cg.id;
                fList.add(fi);
            }
        }
        Database.insert(fList,false);
    }
    
    public static void approverSetting(List<Position__c> pList){
        String eng = 'Engineering';
        String pri = 'Medium';
        Position_Approval_Matrix__c app = database.query('select Department__c,priority__c,Approver_1__c,Approver_2__c,Approver_3__c from Position_Approval_Matrix__c where Department__c=:eng and priority__c =: pri limit 1'); 
        for(Position__c p: pList){
            if(p.Department__c == 'Engineering' && p.priority__c =='Medium'){
                p.Approver_1__c = app.Approver_1__c;
                p.Approver_2__c = app.Approver_2__c;
                p.Approver_3__c = app.Approver_3__c;
            }
        }
    }
}