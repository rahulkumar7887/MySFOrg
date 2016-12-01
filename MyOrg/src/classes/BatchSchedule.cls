global class BatchSchedule {
    global void meth(){
        BatchScheduleTemplate bs = new BatchScheduleTemplate();
        String t = '0 0 13 15 2 ?'; // year month date hr min sec: ---- Feb 15 at 1PM.
        System.schedule('One Time', t, bs);
    }
}