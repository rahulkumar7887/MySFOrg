global class BatchMonitor {
    String batchId;
    global BatchMonitor(Id bId){
        batchId = bId;
    }
    public void meth(){
        //AsyncApexJob batchJobInfo = [Select Id, Status, TotalJobItems, JobItemsProcessed, NumberOfErrors from AsyncApexJob where Id =: batchId];
        List<AsyncApexJob> batchJobInfo = [Select Id, Status, TotalJobItems, JobItemsProcessed, NumberOfErrors from AsyncApexJob where Id =: batchId];
        for(AsyncApexJob b:batchJobInfo){
            System.debug('Id' + b.Id);
            System.debug('Status' + b.Status);
            System.debug('TotalJobItems' + b.TotalJobItems);
            System.debug('JobItemsProcessed' + b.JobItemsProcessed);
            System.debug('NumberOfErrors ' + b.NumberOfErrors );
        } 
    }
}