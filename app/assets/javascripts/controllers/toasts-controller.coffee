ToastsController = ($mdToast, message) ->
  ctrl = @
  ctrl.message = message
  ctrl.mdToast = $mdToast

  ctrl.close = () ->
    ctrl.mdToast.hide()

  return

angular.module('toDoApp').controller 'ToastsController', [
  '$mdToast',
  'message',
  ToastsController
]
