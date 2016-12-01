public class CategoryWrapper {
    public Account acc{ get; set;}
    public Boolean checked{ get; set; }

    public CategoryWrapper(){
        acc = new Account();
        checked = false;
    }

    public CategoryWrapper(Account c){
        acc = c;
        checked = false;
    }
}