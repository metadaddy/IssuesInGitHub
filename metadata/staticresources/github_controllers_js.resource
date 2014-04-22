angular.module('issues.controllers', [])

.controller('IssuesCtrl', function($scope, Issues) {
  console.log('IssuesCtrl');
  Issues.all().then(function(issues) {
	$scope.issues = issues;
  });
})

.controller('IssueDetailCtrl', function($scope, $stateParams, Issues, CaseIssueMapping) {
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
  CaseIssueMapping.get($stateParams.issueId).then(function(cases){
    $scope.cases = cases;
  });
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
