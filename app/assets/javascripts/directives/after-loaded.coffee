AfterLoaded = ($http) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    afterLoaded = attrs.afterLoaded
    scope.isLoading = ->
      $http.pendingRequests.length > 0

    scope.$watch scope.isLoading, (visible) ->
      if visible
        elem.show() if afterLoaded == 'hide'
        elem.hide() if afterLoaded == 'show'
      else
        elem.show() if afterLoaded == 'show'
        elem.hide() if afterLoaded == 'hide'
      return

    return

angular.module('toDoApp').directive 'afterLoaded', ['$http', AfterLoaded]
