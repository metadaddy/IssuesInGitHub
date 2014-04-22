@isTest
public class GithubCallbackControllerTest{
    public static String accessTokenValue = 'ABC123';
    static String clientId = 'ABC123';
    static String clientSecret = '123ABC';
    static String code = 'XYZ789';
    static String state = '/apex/another_page';
    
    static testMethod void testGithubCallbackController(){
        Test.setMock(HttpCalloutMock.class, new GithubCallbackMockGenerator());
        
        GitHub_App_Settings__c setting = 
            new GitHub_App_Settings__c(Name = 'Github App', 
                                       Client_Id__c = clientId,
                                       Client_Secret__c = clientSecret);
        insert setting;
        
        User u = GithubControllerTest.createUser(null);
        System.runAs(u) {
            PageReference pageRef = Page.github_login_html;
            pageRef.getParameters().put('state', state);
            pageRef.getParameters().put('code', code);
            Test.setCurrentPage(pageRef);
            
            Test.startTest();

            GithubCallbackController controller = new GithubCallbackController();
			System.assertEquals(state, controller.state);
			System.assertEquals(accessTokenValue, controller.accessToken);       
            System.assertEquals(null, controller.oauthError);
            System.assertEquals(true, controller.closeWindow);
            
            PageReference next = controller.onLoad();
            
            Test.stopTest();
            
            User u2 = [SELECT GitHubAccessToken__c FROM User WHERE Id = :u.Id];
            System.assertEquals(accessTokenValue, u2.GitHubAccessToken__c);            
        }        
    }
}