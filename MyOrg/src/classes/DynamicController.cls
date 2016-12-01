public with sharing class DynamicController {
    Integer x=0;
    public Component.apex.InputText t1{
        get{
            Component.apex.InputText t1 = new Component.apex.InputText();
            t1.size = 10+x;
            return t1;
        }    
        
    }
    
    public void changeSize(){
        x=x+10;
    }
}