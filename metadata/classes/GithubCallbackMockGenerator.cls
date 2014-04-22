@isTest
global class GithubCallbackMockGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://github.com/login/oauth/access_token', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"'+GithubCallbackControllerTest.accessTokenValue+'"}');
        res.setStatusCode(200);
        return res;
    }
}