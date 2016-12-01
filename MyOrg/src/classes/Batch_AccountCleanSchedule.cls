global class Batch_AccountCleanSchedule implements Schedulable {
	
    global void execute(SchedulableContext sc){
        Batch_AccountClean batchAccClean = new Batch_AccountClean();
        Id batchProcessId = Database.executeBatch(batchAccClean, 100);
        
        //Monitor Batch
        //We cannot add this line to monitor job if there is a scheduled job.
        BatchMonitor bm = new BatchMonitor(batchProcessId); 
    } 
}