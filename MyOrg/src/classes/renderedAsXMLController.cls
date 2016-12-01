public with sharing class renderedAsXMLController {

    public List<Account> getExportValues() {
        
        List<Account> aList = [select id from Account];
        return aList;
    }

}