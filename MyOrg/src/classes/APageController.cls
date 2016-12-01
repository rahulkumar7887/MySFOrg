public class APageController {

    public String Radio { get; set; }
            public String topRadio {get; set;}
            public List<SelectOption> topRadioOptions {get; set;}
            public List<SelectOption> RadioOptions {get;set;}
            public APageController() {
                    RadioOptions = new List<SelectOption>();
                    RadioOptions.add(new SelectOption('Author or Publisher', 'Author or Publisher'));
                    RadioOptions.add(new SelectOption('Museum or Gallery', 'Museum or Gallery'));
                    
                    topRadioOptions = new List<SelectOption>();
                    topRadioOptions.add(new SelectOption('Mobile app or game developer', 'Mobile app or game developer'));
                    topRadioOptions.add(new SelectOption('YouTube video maker','YouTube video maker'));
                    topRadioOptions.add(new SelectOption('Reseller or distributor','Reseller or distributor'));
                    topRadioOptions.add(new SelectOption('Muralist','Muralist'));
                    topRadioOptions.add(new SelectOption('Costume maker','Costume maker'));
                    topRadioOptions.add(new SelectOption('Designer of decals or posters','Designer of decals or posters'));
                    topRadioOptions.add(new SelectOption('Performing arts producer, director, or artist','Performing arts producer, director, or artist'));
                    topRadioOptions.add(new SelectOption('Cake designer or baker','Cake designer or baker'));
                    topRadioOptions.add(new SelectOption('I have a great new idea for Disney','I have a great new idea for Disney'));
                    topRadioOptions.add(new SelectOption('I want to make a T-shirt','I want to make a T-shirt'));
                    topRadioOptions.add(new SelectOption('Church or group seeking a public screening','Church or group seeking a public screening'));
                    topRadioOptions.add(new SelectOption('Other, not listed above','Other, not listed above'));
                   
                 }
            
            public PageReference openNewPage() {
                PageReference pageRef = new PageReference('/apex/AuthorPublisherForm');
                return pageRef;
            } 
            public PageReference openSecondPage(){
                PageReference refPage = new PageReference('/apex/AuthorPublisherForm');
                return refpage;
            }    
}