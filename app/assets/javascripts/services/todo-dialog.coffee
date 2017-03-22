TodoDialog = ($mdDialog) ->
  service = this

  service.default_options =
    controller: 'DialogsController'
    controllerAs: 'dialog'
    parent: angular.element(document.body)
    clickOutsideToClose: true

  service.upload = (object, object_ctrl, type) ->
    options = service.default_options
    Object.assign(options,
      templateUrl: 'todo-dialogs/upload.html',
      locals:
        type: type
        object: object
        object_ctrl: object_ctrl
    )
    $mdDialog.show(options)

  return

angular.module('toDoApp').service 'TodoDialog', ['$mdDialog', TodoDialog]
