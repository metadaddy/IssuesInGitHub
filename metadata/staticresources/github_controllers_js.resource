angular.module('issues.controllers', [])

.controller('IssuesCtrl', function($scope, Issues) {
  console.log('IssuesCtrl');
  Issues.all().then(function(issues) {
	$scope.issues = issues;
  });
})

.controller('IssueDetailCtrl', function($scope, $stateParams, $ionicPopup,
                                        Issues, CaseIssueMapping) {
  console.log('IssueDetailCtrl');
  $scope.linkToCases = ($stateParams.viewIssue === null);
  Issues.get($stateParams.issueId).then(function(issue){
    $scope.issue = issue;
    if (issue.comments > 0) {
      Issues.comments($stateParams.issueId).then(function(comments) {
        $scope.comments = comments;                                                 
      });
    }
  });
  $scope.createCase = function() {
    $ionicPopup.confirm({
      title: 'Create Case',
      content: 'Create Case from Issue \''+$scope.issue.title+'\'?'
    }).then(function(res) {
      if(res) {
        GithubController.createCase($scope.issue.title, $scope.issue.body, 
                                    $stateParams.issueId, function(result, event){
          CaseIssueMapping.clear();
          CaseIssueMapping.get($stateParams.issueId).then(function(cases){
            console.log('cases', cases);
            $scope.issue.cases = cases;
          });
          if (event.status) {
            // Go to case
            navigateToSObject(result);
          }
        });
      }
    });
  };
})

.controller('LinkCtrl', function($scope, $rootScope, Issues, CaseIssueMapping, $q) {
  console.log('LinkCtrl');
  $scope.caseNumber = $rootScope.caseNumber;
    
  $scope.toggleLink = function(issueUrl) {
    console.log('toggleLink', issueUrl);
    $rootScope.linkedIssue = null;
    for (var i = 0; i < $scope.issues.length; i++) {
      $scope.issues[i].linked = (!$scope.issues[i].linked) && ($scope.issues[i].url === issueUrl);
      if ($scope.issues[i].linked) {
        $rootScope.linkedIssue = issueUrl;
      }
    }    
  }

  // Get issues and mapping in parallel
  $q.all({
    issues: Issues.all(), 
    mapping: CaseIssueMapping.all()
  }).then(function(results){
	$scope.issues = results.issues;
    for (var i = 0; i < $scope.issues.length; i++) {
      var cases = results.mapping[$scope.issues[i].url];
      if (cases) {
        for (var j = 0; j < cases.length; j++) {
          if (cases[j].Id === $rootScope.caseId) {
            $scope.issues[i].linked = true;
            break;
          }
        }            
      }
    }
  });
})
