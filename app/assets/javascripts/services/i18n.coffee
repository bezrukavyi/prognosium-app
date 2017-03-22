I18n = ($filter) ->
  service = this

  service.t = (key, options = {}) ->
    $filter('translate')(key, options)

  return

angular.module('toDoApp').service 'I18n', ['$filter', I18n]
