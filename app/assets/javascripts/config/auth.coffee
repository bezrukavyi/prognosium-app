angular.module('toDoApp').config ($authProvider) ->
  $authProvider.configure
    omniauthWindowType: 'newWindow'
    authProviderPaths:
      facebook: '/auth/facebook'
      google:   '/auth/google_oauth2'
