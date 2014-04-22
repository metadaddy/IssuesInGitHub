// Ionic Login App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'login' is the name of this angular module (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('login', ['ionic'])

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
  $stateProvider

    .state('login', {
      url: '/login',
      views: {
        'login': {
          templateUrl: 'login.html',
        }
      },
      onEnter: function(){
        console.log("enter login");
      }
    })

  // Default route
  $urlRouterProvider.otherwise('/login');

})

.filter('encodeURIComponent', function() {
  return window.encodeURIComponent;
})

// So we can follow javascript links in S1
.config(['$compileProvider', function($compileProvider) {
  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|javascript):/);
}]);

