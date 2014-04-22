// Ionic Callback App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'callback' is the name of this angular module (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('callback', ['ionic'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    if(window.StatusBar) {
      StatusBar.styleDefault();
    }
  });
})

.config(function($stateProvider, $urlRouterProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  $stateProvider

    .state('callback', {
      url: '/callback',
      views: {
        'callback': {
          templateUrl: 'callback.html'
        }
      },
      onEnter: function(){
        console.log("enter callback");
      }
    })

  // Default route
  $urlRouterProvider.otherwise('/callback');

})

.filter('encodeURIComponent', function() {
  return window.encodeURIComponent;
})

// So we can follow javascript links in S1
.config(['$compileProvider', function($compileProvider) {
  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|javascript):/);
}]);

