//Controller class for rest api.
public with sharing class RestController {
    public String res{get; set;}
    public String ename{get;set;}
    public String username{get;set;}
    public String pwd{get;set;}
    public String lres{get;set;}
    public void show(){
        Http h= new Http();
        HttpRequest hr = new Httprequest();
        hr.setMethod('GET');
        hr.setEndPoint('https://ap2.salesforce.com/services/apexrest/jyolsna/displayMsg?USERNAME='+ename);
        hr.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        
        HttpResponse hrs = h.send(hr);
        if(hrs.getStatusCode() == 200){
            res=hrs.getBody();
        }
    } 
    public void loginAction(){   
        Http h= new Http();
        HttpRequest hr = new Httprequest();
        hr.setMethod('POST');
        hr.setEndPoint('https://ap2.salesforce.com/services/apexrest/jyolsna/loginUser');
        hr.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        hr.setHeader('Content-Type','application/json; charset=utf8');
        hr.setBody('{"uname":"'+EncodingUtil.urlEncode(username,'UTF-8')+'","pass":"'+EncodingUtil.urlEncode(pwd,'UTF-8')+'"}');
        
        HttpResponse hrs = h.send(hr);
        if(hrs.getStatusCode() == 200){
            lres=hrs.getBody();
        }
    }    
}