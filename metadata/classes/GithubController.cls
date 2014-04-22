global class GithubController {
    public String accessToken {get; set;}
    public String issue {get; set;}
        
    public GithubController() {
        User u = [SELECT Id, GithubAccessToken__c FROM User WHERE Id = :UserInfo.GetUserId()];
        accessToken = u.GithubAccessToken__c;        
        issue = ApexPages.currentPage().getParameters().get('issue');
    }
    
    public GithubController(ApexPages.StandardController controller) {
        this();
    }
    
    public PageReference onLoad() {
        // Check that we have an access token for this user
        if (accessToken == null) {
            // If not, we need to log the user in
            PageReference page = new PageReference('/apex/github_login_html');
            page.getParameters().put('state', ApexPages.currentPage().getUrl());
            return page;
        }
        return null;
    }
    
    @RemoteAction
    global static void deleteAccessToken() {
        User u = [SELECT Id, GithubAccessToken__c FROM User WHERE Id = :UserInfo.GetUserId()];
        u.GithubAccessToken__c = null;
        update u;
    }
    
    @RemoteAction
    global static void attachIssue(Id caseId, String issueUrl) {
        Case c = [SELECT Id FROM Case WHERE Id = :caseId];
        
        c.GitHub_Issue__c = issueUrl;
        
        update c;
    }
    
    @RemoteAction
    global static String getJsonIssueCaseMapping() {
	    Map<String, List<Case>> issueCaseMapping = new Map<String, List<Case>>();
        
        for (Case c : [select GitHub_Issue__c, CaseNumber, Id 
                       from Case 
                       where GitHub_Issue__c != null 
                       order by CaseNumber]) {
            List<Case> cases = issueCaseMapping.get(c.GitHub_Issue__c);
            if (cases == null) {
               	cases = new List<Case>();
                issueCaseMapping.put(c.GitHub_Issue__c, cases);
            }
            cases.add(c);
        }
        
		return JSON.serialize(issueCaseMapping);        
    }
}