ForecastsController = (Forecast, TodoToast, I18n, Access, $state, $filter) ->
  ctrl = @

  ctrl.update = (form, forecast) ->
    return if form.$invalid || !Access.can('request')
    Access.lock('request')
    Forecast.default.update(forecast).$promise.then (
      (response) ->
        Object.assign(forecast, response)
        TodoToast.success(I18n.t('data.success.updated'))
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.upload = (form, forecast, file) ->
    return if !file || form.$invalid || !Access.can('request')
    Access.lock('request')
    Forecast.upload(file, forecast, 'put').then (
      (response) ->
        Object.assign(forecast, response.data)
        TodoToast.success(I18n.t('data.success.updated'))
      ), (response) ->
        TodoToast.error(response.data.error)

  return


angular.module('toDoApp').controller 'ForecastsController', [
  'Forecast',
  'TodoToast',
  'I18n',
  'Access',
  '$state',
  '$filter',
  ForecastsController
]
