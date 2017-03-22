angular.module('toDoApp').config ($mdThemingProvider, $mdIconProvider) ->
  $mdThemingProvider
    .theme('default')
    .primaryPalette('blue')
    .accentPalette('blue')
  $mdIconProvider
    .fontSet('md-icons', 'material-icons')
