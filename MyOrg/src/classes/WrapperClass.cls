global class WrapperClass {
    public Boolean bool{get;set;}
    public Account acc{get;set;}
    
    public WrapperClass() { }
    
    public WrapperClass(Account a) {
        bool = true;
        acc = a;
    }
}