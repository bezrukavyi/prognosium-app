angular.module('toDoApp').config ($translateProvider) ->
  $translateProvider.useStaticFilesLoader
    prefix: 'api/translations/',
    suffix: '.json'
  $translateProvider.useSanitizeValueStrategy('escapeParameters')
  $translateProvider.preferredLanguage('en')
  $translateProvider.useLocalStorage()
  $translateProvider.forceAsyncReload(true)

angular.module('toDoApp').run ($rootScope, $translate, $filter) ->
  $rootScope.changeLocale = (langKey) ->
    $translate.use(langKey)
