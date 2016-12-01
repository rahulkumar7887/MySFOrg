public class PositionException extends Exception{
    String errMessage;
    public PositionException(String errMessage, SObject s){
        this.errMessage = errMessage;
    }
    public string displayError(){
        return errMessage;
    }
}