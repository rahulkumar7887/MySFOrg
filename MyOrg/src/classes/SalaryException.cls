public class SalaryException extends Exception{
    String errMessage;
    public SalaryException(String errMessage, SObject s){
        this.errMessage = errMessage;
    }
    public string displayError(){
        return errMessage;
    }
}