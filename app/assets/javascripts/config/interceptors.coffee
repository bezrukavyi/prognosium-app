AccessRequestInterceptors = (Access, $q) ->
  response: (result) ->
    Access.request = true

    result

angular.module('toDoApp').config ($httpProvider) ->
  $httpProvider.interceptors.push(AccessRequestInterceptors)
