public with sharing class PosexController {
    public Decimal hra{get;set;}
    public decimal allowance{get; set;}
    public decimal grossPay{get; set;}
    Position__c p;
    public PosexController(ApexPages.StandardController controller) {
        p=(Position__c)controller.getRecord();
    }
    public void calc(){
        decimal avgPay = (p.min_pay__c+p.max_pay__c)/2;
        hra = avgpay*0.35;
        allowance  = avgpay*0.2;
        grosspay = avgpay+hra+allowance;
    }
}