public class LeadTriggerHandler {
	
    public static void convertLead(List<Lead> lstLead){
        for(Lead lead: lstLead){
            System.debug('#Lead' + lead);
            if(lead.isconverted == false) {
                Database.LeadConvert leadConvert = new database.LeadConvert();
        		leadConvert.setLeadId(lead.Id);
                
                Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
        		System.debug('##leadConvertResult' + leadConvertResult);
                System.assert(leadConvertResult.isSuccess());
            }            
        }
    }
}