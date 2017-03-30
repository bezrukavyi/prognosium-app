FormError = () ->
  service = @

  service.fill = (form, response) ->
    angular.forEach response.data.errors, (errors, field) ->
      form[field].$setValidity('server', false)
      form[field].errors = errors.join(', ')

  return

angular.module('toDoApp').service 'FormError', [FormError]
