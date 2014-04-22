// Ionic Issues App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'issues' is the name of this angular module (also set in a <body> attribute in github_app_html)
// the 2nd parameter is an array of 'requires'
// 'issues.services' is found in github_services_js
// 'issues.controllers' is found in github_controllers_js
// 'angularMoment' is found in github_app_resources
angular.module('issues', ['ionic', 'issues.controllers', 'issues.services', 'angularMoment'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if(window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
  });
})

.config(function($stateProvider, $urlRouterProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in github_controllers_js
  $stateProvider

    // Date.now() in path to bust browser cache
    .state('issues', {
      url: '/issues',
      views: {
        'issues': {
          templateUrl: '/resource/'+Date.now()+'/github_issues_html',
          controller: 'IssuesCtrl'
        }
      },
      onEnter: function(){
        console.log("enter issues");
      }
    })
    .state('issue-detail', {
      url: '/issue?issueId&viewIssue',
      views: {
        'issues': {
          templateUrl: '/resource/'+Date.now()+'/github_issue_detail_html',
          controller: 'IssueDetailCtrl'
        }
      },
      onEnter: function(){
        console.log("enter issue-detail");
      }
    })
    .state('link', {
      url: '/link',
      views: {
        'issues': {
          templateUrl: '/resource/'+Date.now()+'/github_link_html',
          controller: 'LinkCtrl'
        }
      },
      onEnter: function(){
        console.log("enter link");
      }
    })

  // if we have a case, we want to link it to an issue
  // otherwise show the list of issues
  $urlRouterProvider.otherwise((typeof github_caseNumber !== 'undefined') ? '/link' : '/issues');

})

.filter('encodeURIComponent', function() {
  return window.encodeURIComponent;
})

// So we can follow javascript links in S1
.config(['$compileProvider', function($compileProvider) {
  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|javascript):/);
}]);;

