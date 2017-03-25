AccessRequestInterceptors = (Access, $q) ->
  response: (response) ->
    Access.request = true
    response

  responseError: (response) ->
    Access.request = true
    $q.reject(response)

angular.module('toDoApp').config ($httpProvider) ->
  $httpProvider.interceptors.push(AccessRequestInterceptors)
