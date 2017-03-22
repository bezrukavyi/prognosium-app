SessionsController = ($auth, $rootScope, $state, I18n, TodoToast, Omniauth) ->
  ctrl = @
  ctrl.new = {}

  ctrl.signIn = (form) ->
    return if form.$invalid
    $auth.submitLogin(ctrl.new).then (
      (response) ->
        $state.go 'projects'
        TodoToast.success(I18n.t('auth.success.sign_in'))
        ctrl.resetNew(form)
      ), (response) ->
        TodoToast.error(response.errors[0])

  ctrl.omniauth = (provider) ->
    Omniauth.call(provider)

  ctrl.resetNew = (form) ->
    form.$setPristine()
    form.$setUntouched()
    ctrl.new = {}

  return

angular.module('toDoApp').controller 'SessionsController', [
  '$auth',
  '$rootScope',
  '$state',
  'I18n',
  'TodoToast',
  'Omniauth',
  SessionsController
]
