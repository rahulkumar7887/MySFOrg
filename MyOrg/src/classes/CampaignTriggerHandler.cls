public class CampaignTriggerHandler {
    
    public static void createCampaignMembers(List<Campaign> cList){
    	List<CampaignMember> lstCampaignMembers = new List<CampaignMember>();
    	CampaignMember campaignMember;
    
        for(Campaign c: cList){
            //lstCampaignMembers.add(new CampaignMember(Campaign = c.Id));    
            campaignMember = new CampaignMember();
            campaignMember.CampaignId = c.Id;
            lstCampaignMembers.add(campaignMember);
        }
        insert lstCampaignMembers;
    }
    
    public static void createCampaignMemberStatus(List<Campaign> cList){
        List<CampaignMemberStatus> lstCampaignMemberStatus = new List<CampaignMemberStatus>();
        for (Campaign c: cList){
            //if(campaignMemberStatus.Label == 'Responded'){ 
                CampaignMemberStatus cms1 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=true, Label='Show', SortOrder=1);	
           		lstCampaignMemberStatus.add(cms1);
            //}
			//else if(campaignMemberStatus.Label == 'Sent'){ 
				CampaignMemberStatus cms2 = new CampaignMemberStatus(CampaignId=c.Id, HasResponded=False, Label='No Show', SortOrder=2);
            	lstCampaignMemberStatus.add(cms2);
            //}
		}
        insert lstCampaignMemberStatus;
    }
    
    public static void changeLabel(List<Campaign> cList){
        List<CampaignMemberStatus> lstCampaignMemberStatus = [Select Id, Label FROM CampaignMemberStatus WHERE CampaignID =: cList[0].Id]; 
        for (CampaignMemberStatus campaignMemberStatus:lstCampaignMemberStatus){ 
            if(campaignMemberStatus.Label == 'Responded'){ 
                campaignMemberStatus.Label = 'Show'; 
            } 
        }
    }
}