@isTest
public class GithubLoginControllerTest{
    static String accessTokenValue = 'ABC123';
    static String clientId = 'ABC123';
    static String clientSecret = '123ABC';
    static String state = '/apex/another_page';
    
    static testMethod void testGithubLoginController(){
        
        GitHub_App_Settings__c setting = 
            new GitHub_App_Settings__c(Name = 'Github App', 
                                       Client_Id__c = clientId,
                                       Client_Secret__c = clientSecret);
        insert setting;
        
        User u = GithubControllerTest.createUser(accessTokenValue);
        System.runAs(u) {
            PageReference pageRef = Page.github_login_html;
            pageRef.getParameters().put('state', state);
            Test.setCurrentPage(pageRef);

            GithubLoginController controller = new GithubLoginController();
			System.assertEquals(clientId, controller.clientId);
			System.assertEquals(state, controller.state);            
        }        
    }
}