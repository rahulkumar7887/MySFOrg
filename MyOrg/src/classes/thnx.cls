public with sharing class thnx {
    public String currentRecordId {set;get;}
    public thnx(ApexPages.StandardController controller) {
        currentRecordId = controller.getRecord().Id;
    }

}