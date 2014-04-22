@isTest
public class GithubControllerTest{
    static String accessTokenValue = 'ABC123';
    static String issueUrl = 'https://api.github.com/repos/testuser/testrepo/issues/1';
    
    public static User createUser(String accessToken) {
        Profile standardUser = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'test', 
                          Email = 'githubtester@devorg.pat',
                          LastName = 'Tester',
                          ProfileId = standardUser.Id,
                          Username = 'githubtester@devorg.pat',
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          LanguageLocaleKey = 'en_US',
                          GitHubAccessToken__c = accessToken);
            
        insert u;

		return u;        
    }
    
    static testMethod void testGithubControllerAccessToken(){
        User u = createUser(accessTokenValue);
        System.runAs(u) {
            PageReference pageRef = Page.github_app_html;
            Test.setCurrentPage(pageRef);

            GithubController controller = new GithubController();
            
            // Does the controller have the access token?
            System.assertEquals(accessTokenValue, controller.accessToken);
            
            // We shouldn't redirect on load
            PageReference next = controller.onLoad();
            System.assertEquals(null, next);
        }        
    }

    static testMethod void testGithubControllerNoAccessToken(){
        User u = createUser(null);
        System.runAs(u) {
            PageReference pageRef = Page.github_app_html;
            Test.setCurrentPage(pageRef);

            // Check for no access token
            GithubController controller = new GithubController();
            System.assertEquals(null, controller.accessToken);
            
            // We should redirect on load
            PageReference next = controller.onLoad();
            System.assertEquals(next.getUrl(), 
                                '/apex/github_login_html?state='+EncodingUtil.urlEncode(pageRef.getUrl(), 'UTF-8'));
            
            // State should be set to bring us back here
            System.assertEquals(pageRef.getUrl(), next.getParameters().get('state'));
        }        
    }
    
    static testMethod void testGithubControllerExtension(){
        User u = createUser(accessTokenValue);
        System.runAs(u) {
            Case c = new Case();
            insert c;
            
            ApexPages.StandardController sc = new ApexPages.standardController(c);
            GithubController controller = new GithubController(sc);
            
            // Does the controller have the access token?
            System.assertEquals(accessTokenValue, controller.accessToken);
        }        
    }

    static testMethod void testDeleteAccessToken(){
        User u = createUser(accessTokenValue);
        System.runAs(u) {
            GithubController.deleteAccessToken();
            
            User u2 = [SELECT GitHubAccessToken__c FROM User WHERE Id = :u.Id];
            System.assertEquals(null, u2.GitHubAccessToken__c);
        }        
    }
    
    static testMethod void testAttachIssue(){
        User u = createUser(accessTokenValue);
        System.runAs(u) {
            Case c = new Case();
            
            insert c;
            
            GithubController.attachIssue(c.Id, issueUrl);
            
            Case c2 = [SELECT GitHub_Issue__c FROM Case WHERE Id = :c.Id];
            System.assertEquals(issueUrl, c2.GitHub_Issue__c);
        }        
    }
    
    static testMethod void testGetJsonIssueCaseMapping(){
        User u = createUser(accessTokenValue);
        System.runAs(u) {
            Case c = new Case();
            
            insert c;
            
            GithubController.attachIssue(c.Id, issueUrl);
            
            String jsonData = GithubController.getJsonIssueCaseMapping();
            
            Map<String, Object> mapping = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
            
            List<Object> cases = (List<Object>)mapping.get(issueUrl);
            System.assertNotEquals(null, cases);

            Map<String, Object> myCase = (Map<String, Object>)cases[0];
            System.assertEquals(c.Id, myCase.get('Id'));
        }        
    }
}