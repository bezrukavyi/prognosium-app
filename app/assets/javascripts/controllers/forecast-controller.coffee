ForecastsController = (Forecast, TodoToast, I18n, Access, $state, $filter, FormError) ->
  ctrl = @

  ctrl.update = (form, forecast) ->
    return if form.$invalid || !Access.can('request')
    Access.lock('request')
    Forecast.default.update(forecast).$promise.then (
      (response) ->
        delete response.$promise
        delete response.$resolved
        Object.assign(forecast, response)
      ), (response) ->
        TodoToast.error(I18n.t('errors.messages.invalid'))
        FormError.fill(form, response)

  ctrl.upload = (form, forecast, file) ->
    return if !file || form.$invalid || !Access.can('request')
    Access.lock('request')
    Forecast.upload(file, forecast, 'put').then (
      (response) ->
        Object.assign(forecast, response.data)
        TodoToast.success(I18n.t('data.success.updated'))
      ), (response) ->
        error_message = response.data.error || I18n.t('errors.messages.invalid')
        TodoToast.error(error_message)
        FormError.fill(form, response)

  return


angular.module('toDoApp').controller 'ForecastsController', [
  'Forecast',
  'TodoToast',
  'I18n',
  'Access',
  '$state',
  '$filter',
  'FormError',
  ForecastsController
]
