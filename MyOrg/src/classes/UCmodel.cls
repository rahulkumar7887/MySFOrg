public abstract class UCmodel implements UCapp{
    public void welcomeMsg(){
        system.debug('Welcome to Universal Containers');
    }
    public abstract void calcTax(Position__c p);
}