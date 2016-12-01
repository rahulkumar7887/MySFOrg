//webservice class
global class Display{
    /*webservice static String showUser(){
        string uname = UserInfo.getFirstname()+' ' +UserInfo.getLastname();
        return uname;
    }*///without parameter
    
    //2nd task with parameters
    webservice static String showUser(String name, String dept){
        Position__c p = [select name , department__c,status__c from Position__c where name=:(name) and department__c =:(dept) limit 1];
        return p.name+' '+p.department__c+' '+p.status__c;
    }
    
    //3rd task insert candidate and return success or error msg
    webservice static String candidateValidate(String firstname,String lastname, String city){
       // List<Candidate__c> cList = new List<Candidate__c>();
       String str;
        Candidate__c c = new candidate__c( First_Name__c = firstname,Last_Name__c = lastname,City__c = city);
        if(firstname!=''&& lastname!= ''&& city!=''){
           try{
                insert c;
                if(c.id != null){
                    str = 'Insert Successfull';
                }
            }catch(Exception e){
                str = e.getMessage();
            }
        }
        else
        str = 'Insert Unsuccessfull';
        return str;
    }
}