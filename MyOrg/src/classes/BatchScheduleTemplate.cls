global class BatchScheduleTemplate implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchClassTemplate batch = new BatchClassTemplate();
        //no of records to be passed in each batch item
        Id batchProcessId = Database.executeBatch(batch, 150); 
        //Monitor Batch
        BatchMonitor bm = new BatchMonitor(batchProcessId);    
    }
}