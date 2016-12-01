public class apexRestCallout {
    
    private static HttpRequest req;
    private static HttpResponse res;
    private static Http http;
    
    public void callout() {
        req = new HttpRequest();
        res = new HttpResponse();
        http = new Http();
        
        res = http.send(req);
    }
}