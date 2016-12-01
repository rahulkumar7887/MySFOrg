public with sharing class SOQLController {
    public String objname{get;set;}
    public String flds{get;set;}
    public String res{get;set;}
    public List<String> rList{get;set;}
    public void showData(){
        try{
            List<SObject> sList = Database.query('select '+flds+' from '+objname);
            List<String> fldList = flds.split(',');
            rList = new List<String>();
            for(SObject s: sList){
                String r = '';
                for(Integer i =0;i<fldList.size();i++){
                    r=r+' '+s.get(fldList.get(i));
                }
                rList.add(r);
            }
            res=null;
        }catch(System.Exception ex){
            res=ex.getMessage();
            rList=null;
        }
    }
}