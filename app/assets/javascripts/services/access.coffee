Access = ($parse) ->
  service = this

  service.request = null

  service.can = (type) ->
    parse_type = $parse("#{type}")(service)
    parse_type == true || parse_type == null

  service.lock = (type) ->
    $parse("#{type}").assign(service, false)

  return

angular.module('toDoApp').service 'Access', Access
