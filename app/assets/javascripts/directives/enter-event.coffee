angular.module('toDoApp').directive 'enterEvent', ($parse) ->
  restrict: 'A'
  link: (scope, element, attr) ->
    enterHandler = $parse(attr.enterEvent)
    element.on 'keydown', (event) ->
      if event.keyCode == 13 && !event.shiftKey
        event.preventDefault()
        enterHandler(scope)
        element.blur()
      return

    return
