UsersController = ($auth, $state, I18n, TodoToast, Omniauth) ->
  ctrl = @

  ctrl.new = {
    email: null,
    password: null,
    password_confirmation: null
  }

  ctrl.resetNew = () ->
    ctrl.new = {}

  ctrl.create = (form) ->
    return if form.$invalid
    $auth.submitRegistration(ctrl.new)
    .then((response) ->
      TodoToast.success(I18n.t('auth.success.sign_up'))
      return
    )
    .catch((response) ->
      TodoToast.error(response.data.errors.full_messages[0])
      return
    )

  ctrl.omniauth = (provider) ->
    Omniauth.call(provider)

  return

angular.module('toDoApp').controller 'UsersController', [
  '$auth',
  '$state',
  'I18n',
  'TodoToast',
  'Omniauth',
  UsersController
]
