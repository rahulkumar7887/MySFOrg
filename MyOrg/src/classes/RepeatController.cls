public class RepeatController {
    public List<RowObject> RowObjectList{get;set;}
        
    public class RowObject {
  
    }
    
    public RepeatController() {
        RowObjectList = new List<RowObject>();
        RowObjectList.add(new RowObject());
        RowObjectList.add(new RowObject());
        RowObjectList.add(new RowObject());
        RowObjectList.add(new RowObject());
        RowObjectList.add(new RowObject());
    } 
    
    public void addRow(){
       RowObjectList.add(new RowObject());
    }
}