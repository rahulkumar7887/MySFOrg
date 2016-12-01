global class contactBactchScheduler implements Schedulable {

    global void execute (SchedulableContext ctx) {
        String query = 'Select Id,AccountId,LastName from Contact';
        contactBatchClass batch = new contactBatchClass(query);
        Database.executeBatch(batch);
    }
}