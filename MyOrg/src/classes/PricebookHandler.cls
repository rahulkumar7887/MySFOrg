public class PricebookHandler {
    public static void updatePBE(Map<Id,Pricebook2> mapPricebook2){
        System.debug('#mapPricebook2' + mapPricebook2);
        List<PricebookEntry> lstPricebookEntry;
        //lstPricebookEntry = [Select Id, Name From PricebookEntry Where Pricebook2Id IN =: mapPricebook2.keySet()];
        //for(PricebookEntry pbe: lstPricebookEntry){
    		//System.debug('##pbe' + pbe);
		//}
    }
}