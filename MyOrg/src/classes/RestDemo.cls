//Rest Class
@RestResource(urlMapping='/rahul/*')
global class RestDemo{
    @HttpGet//get method dont have parameters
    global static String displayMsg(){
        String u=RestContext.request.params.get('USERNAME');
        return 'Hello Rest Service'+' '+u.toUpperCase();
    }
    @HttpPost//post method
    global static String loginUser(String uname, String pass){
        if(uname.equalsIgnoreCase('acc') && pass.equalsIgnoreCase('p001')){
            return 'Valid User';
        }
        else{
            return 'Invalid USer';
        }
    }
}