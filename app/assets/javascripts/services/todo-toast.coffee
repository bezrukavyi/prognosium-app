TodoToast = ($mdToast) ->
  service = this

  service.default_options =
    hideDelay: 1500,
    position: 'top right',
    controller: 'ToastsController',
    controllerAs: 'toast'

  service.error = (message) ->
    options = service.default_options
    Object.assign(options,
      templateUrl: 'todo-toasts/error-toast.html',
      locals: message: message
    )
    $mdToast.show(options)

  service.success = (message) ->
    options = service.default_options
    Object.assign(options,
      templateUrl: 'todo-toasts/success-toast.html',
      locals: message: message
    )
    $mdToast.show(options)

  return

angular.module('toDoApp').service 'TodoToast', ['$mdToast', TodoToast]
