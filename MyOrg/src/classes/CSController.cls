public with sharing class CSController {
    public String cemail{get;set;}
    public String res{get;set;}
    
    public void show(){
        
        partnerStub.Soap sp = new PartnerStub.Soap();
        partnerStub.loginResult lr = sp.login('jyolsna.raghavan-hkqe@force.com','glitter123') ;
        CandidateStub.CandidateCheck ck = new  CandidateStub.CandidateCheck();
        CandidateStub.SessionHeader_element  se = new CandidateStub.SessionHeader_element();
        //se.sessionId = UserInfo.getSessionId();
        se.sessionId = lr.sessionId;
        ck.sessionHeader = se;
        try{
            res = ck.checkCandidate(cemail);
        }catch(CalloutException ce){
            res=ce.getMessage();
        }
    }
}