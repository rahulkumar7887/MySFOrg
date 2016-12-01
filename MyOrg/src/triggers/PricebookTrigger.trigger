trigger PricebookTrigger on Pricebook2 (before insert) {
    if(Trigger.isBefore){
        PricebookHandler.updatePBE(Trigger.newMap);
    }
}