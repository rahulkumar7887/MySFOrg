public with sharing class CustomSettingDemo {
    public List<CountryCode__c> name {get;set;}
    public Set<String> cName{Set;Get;}
    public List<CountryCode__c> cc{get;set;}
    public CustomSettingDemo()
    {
        Map<String,CountryCode__c> allCodes = CountryCode__c.getAll();
        name = allCodes.values();
        cName = allCodes.keySet();
        //cc = List<CountryCode__c>.getInstance(cName);
    }
}