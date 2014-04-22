public class GithubLoginController{
    public String state {get; set;}
    public String clientId {get; set;}
    
    public GithubLoginController() {
        GitHub_App_Settings__c settings = GitHub_App_Settings__c.getValues('Github App');
        state = ApexPages.currentPage().getParameters().get('state');
        clientId = settings.client_Id__c;
    }
}