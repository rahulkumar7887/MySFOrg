public class OpportunityLineItemTriggerHelper {
    public static void createSchedules(List<OpportunityLineItem> lstOpportunityLineItem){
        Map<Id, Product2> mapProduct = new Map<Id, Product2>([Select Id, IsActive, Name, CanUseQuantitySchedule, CanUseRevenueSchedule from Product2]);
        List<OpportunityLineItemSchedule> schedules = new List<OpportunityLineItemSchedule>();
        for (OpportunityLineItem oli : lstOpportunityLineItem){
            if(!mapProduct.isEmpty() && mapProduct.containsKey(oli.Product2Id)){
                Product2 prod2 = mapProduct.get(oli.Product2Id);
                if(prod2.IsActive && prod2.CanUseQuantitySchedule && prod2.CanUseRevenueSchedule){
                	schedules.add(
                        new OpportunityLineItemSchedule(
                            OpportunityLineItemId = oli.Id,
                            Type = 'Both', //Quantity|Revenue|Both
                            ScheduleDate = System.today() ,
                            Quantity = 20, //Optional when Type = 'Revenue'
                            Revenue = 1000 //Optional when Type = 'Quantity'
                            //QuantityScheduleType = '' 
                            //InstallementPeriod = 4                      
                        )
                    );    
                }
                else if(prod2.IsActive && prod2.CanUseQuantitySchedule){
                	schedules.add(
                        new OpportunityLineItemSchedule(
                            OpportunityLineItemId = oli.Id,
                            Type = 'Quantity',
                            ScheduleDate = System.today(),
                            Quantity = 20                      
                        )
                    );    
                }
                else if(prod2.IsActive && prod2.CanUseRevenueSchedule){
                	schedules.add(
                        new OpportunityLineItemSchedule(
                            OpportunityLineItemId = oli.Id,
                            Type = 'Revenue',
                            ScheduleDate = System.today(),
                            Revenue = 1000                     
                        )
                    );    
                }
            }        	 
        }
        insert schedules;
    }
}