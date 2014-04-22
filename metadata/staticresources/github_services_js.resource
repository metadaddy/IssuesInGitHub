angular.module('issues.services', [])

.factory('Issues', function($q, $rootScope) {
  console.log('issues.services factory');
    
  // Github API accessors
  var user   = $rootScope.github.getUser();
  var issues = $rootScope.github.getIssues();

  // Cached array of issues from GitHub
  var issueList;
  // Map from URL to issue
  var issueMap;

  return {
    all: function() {
      var deferred = $q.defer();
        
      if (issueList) {
         // Use cached array
         deferred.resolve(issueList); 
      }
      
      // Get issue list from GitHub
      issues.list({
        all: true
      }, function(err, resp){
        if (err) {
          // Token is probably revoked/expired - trigger login
          deferred.reject(err);
          GithubController.deleteAccessToken(function(result, event){
            if (event.status) {
              navigateToURL('/apex/github_login_html?state='+encodeURIComponent('/apex/github_app_html'));
            }
          });
        } else {
          // We have the issues!
          console.log('issues', resp);
          issueList = resp;
          // Build a map from issue URL to issue object
          issueMap = {}
          for (var i = 0; i < issueList.length; i++) {
              issueMap[issueList[i].url] = issueList[i];
          }
          deferred.resolve(issueList);
        }
      });

      return deferred.promise;
    },
    get: function(issueUrl) {
      var deferred = $q.defer();
      if (issueMap) {
	    deferred.resolve(issueMap[issueUrl]);          
      } else {
        return this.all().then(function(){
          return issueMap[issueUrl];
        });
      }

      return deferred.promise;
    },
    comments: function(issueUrl) {
      var deferred = $q.defer();
      this.get(issueUrl).then(function(issue){
        // Get comments from GitHub
        issues.get(issue.comments_url, function(err, comments){
          if (err) {
            deferred.fail(err);
          } else {
            console.log('comments', comments);
            deferred.resolve(comments);
          }
        });  
      });
      return deferred.promise;
    }
  }
})

.factory('CaseIssueMapping', function($q) {
  var mapping;
    
  return {
    all: function() {
      var deferred = $q.defer();
        
      if (mapping) {
         deferred.resolve(mapping); 
      }
      
      // Get mapping of issues to cases from Apex controller
      GithubController.getJsonIssueCaseMapping(function(result, event){
        if (event.status) {
          mapping = JSON.parse(result);
          deferred.resolve(mapping);
        } else {
          deferred.reject(event);
        }
      }, {
        escape: false
      });

      return deferred.promise;
    },
    get: function(issueUrl) {
      var deferred = $q.defer();
      
      if (mapping) {
	    deferred.resolve(mapping[issueUrl]);          
      } else {
        return this.all().then(function(){
          return mapping[issueUrl];
        });
      }

      return deferred.promise;      
    }
  }
});
