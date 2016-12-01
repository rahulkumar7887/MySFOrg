public class PositionImpl extends PositionHelper{

    static PositionImpl pi;
    public static PositionImpl getInstance(){
        if(pi == null){
            pi = new PositionImpl();
        }
        return pi;
    }
    private PositionImpl(){
        
    }
    public override void calcTax(Position__c p){
        Double avgPay = (p.min_pay__c+p.max_pay__c)/2;
        Double tax = avgPay*0.15;
        system.debug('tax payable is '+ tax);
    }
    public void checkSal(Position__c p){
        if(p.min_pay__c > 10000){
            calcTax(p);
        }
        else{
            super.calcTax(p);
        }
        
    }
    
    public void checkRecordforComp(Position__c p){
        if(p!=null){
            try{
                checkPay(p);
            }catch(PositionException pe){
                system.debug(pe.displayError());
            }
        }
    }
}