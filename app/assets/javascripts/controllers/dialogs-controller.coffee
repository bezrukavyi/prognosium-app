DialogsController = ($mdDialog, object, object_ctrl, type) ->
  ctrl = @
  ctrl.object = object
  ctrl.object_ctrl = object_ctrl
  ctrl.type = type
  ctrl.mdDialog = $mdDialog

  ctrl.close = () ->
    ctrl.mdDialog.hide()

  return

angular.module('toDoApp').controller 'DialogsController', [
  '$mdDialog',
  'object',
  'object_ctrl',
  'type',
  DialogsController
]
