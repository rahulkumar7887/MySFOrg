public class OpportunityPieChartController{
    
    public List<Opportunity> aList;
    public List<Case> cList;
    
    public AggregateResult[] newCasesOnAccount{get;set;}
    public AggregateResult[] workingCasesOnAccount{get;set;}
    public AggregateResult[] escalatedCasesOnAccount{get;set;}
    public AggregateResult[] closedCasesOnAccount{get;set;}
    
    Id pageId = ApexPages.currentPage().getParameters().get('id');
    
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        aList = [Select Id, Number_of_Cases__c, (Select Id, Status from Cases__r) from Opportunity where Id =: pageId];
        System.debug('Account List' + aList);
        for(Opportunity a: aList) {
            //cList = a.Cases__r;
            //System.debug('Case List' + cList);
            newCasesOnAccount = [Select Count(Status) from Case where Status = 'New' AND CreatedDate = THIS_MONTH AND Opportunity__r.Id =: a.Id]; 
            workingCasesOnAccount = [Select Count(Status) from Case where Status = 'Working' AND CreatedDate = THIS_MONTH AND Opportunity__r.Id =: a.Id];
            escalatedCasesOnAccount = [Select Count(Status) from Case where Status = 'Escalated' AND CreatedDate = THIS_MONTH AND Opportunity__r.id =: a.Id];
            closedCasesOnAccount = [Select Count(Status) from Case where Status = 'Closed' AND CreatedDate = THIS_MONTH AND Opportunity__r.Id =: a.Id];
        }     
        System.debug('newCasesOnAccount List' + newCasesOnAccount );    
        System.debug('workingCasesOnAccount List' + workingCasesOnAccount );
        System.debug('escalatedCasesOnAccount  List' + escalatedCasesOnAccount );
        System.debug('closedCasesOnAccount  List' + closedCasesOnAccount );
                
        for(AggregateResult ar: newCasesOnAccount) 
        {
            System.debug('newCasesOnAccount List' + ar.get('expr0'));
            data.add(new PieWedgeData('New', ar.get('expr0')));
        } 
        
        data.add(new PieWedgeData('Working', workingCasesOnAccount[0].get('expr0')));
        data.add(new PieWedgeData('Escalated', escalatedCasesOnAccount[0].get('expr0')));
        data.add(new PieWedgeData('Closed', closedCasesOnAccount[0].get('expr0')));
        return data;
    }

    // Wrapper class
    public class PieWedgeData {

        public String name { get; set; }
        public Object data { get; set; }

        public PieWedgeData(String name, Object data) {
            this.name = name;
            this.data = data;
        }
    }
}