public class GithubCallbackController{
    public String body { get; set; }
    public String accessToken { get; set; }
    public String oauthError { get; set; }
    public String state { get; set; }
    public Boolean closeWindow { get; set; }
    public GithubCallbackController(){
        GitHub_App_Settings__c settings = GitHub_App_Settings__c.getValues('Github App');
        state = ApexPages.currentPage().getParameters().get('state');
        String code = ApexPages.currentPage().getParameters().get('code');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://github.com/login/oauth/access_token');
        req.setBody('&client_id=' + EncodingUtil.urlEncode(settings.client_Id__c, 'UTF-8') +
                    '&client_secret=' + EncodingUtil.urlEncode(settings.client_Secret__c, 'UTF-8') +
                    '&code=' + EncodingUtil.urlEncode(code, 'UTF-8'));
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        Http h = new Http();
        HttpResponse res = h.send(req);
        body = res.getBody();
        Map<String, Object> oauth = (Map<String, Object>)JSON.deserializeUntyped(body);
        accessToken = (String)oauth.get('access_token');
        oauthError = (String)oauth.get('error');
        // Sometimes the parent window wins the race, and loads the iframe before we
        // get the code here!
        if (accessToken != null || 
            (oauthError != null && oauthError.equals('bad_verification_code'))) {
            closeWindow = true;
        }
    }
    
    public PageReference onLoad() {
        if (accessToken != null) {
            User u = [SELECT Id, GitHubAccessToken__c FROM User WHERE Id = :UserInfo.getUserId()];
            if (u.GitHubAccessToken__c != accessToken) {
	            u.GitHubAccessToken__c = accessToken;
                update u;
            }
        }
        return null;
    }
}