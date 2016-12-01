public with sharing class QuestionCtrl {
    
    public String q1{get;set;}
    public String q2{get;set;}
    public String q3{get;set;}
        
    public QuestionCtrl(ApexPages.StandardController controller) {
        
    }   
    
    public PageReference saveQuestionRecords(){
        System.debug('##q1##' + q1);
        System.debug('##q2##' + q2);
        return null;
    }
}