angular.module('toDoApp').config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $stateProvider
  .state 'main',
    url: ''
    controller: 'MainController'
    controllerAs: 'main'
    templateUrl: 'layouts/app.html'

  .state 'sign_in',
    url: '/sign_in'
    parent: 'main'
    templateUrl: 'sessions/new.html'
    controller: 'SessionsController'
    controllerAs: 'session'
    resolve: auth: redirectAuthed

  .state 'sign_up',
    url: '/sign_up'
    parent: 'main'
    templateUrl: 'users/new.html'
    controller: 'UsersController'
    controllerAs: 'user',
    resolve: auth: redirectAuthed

  .state 'projects',
    url: '/projects'
    parent: 'main'
    controller: 'ProjectsController'
    controllerAs: 'projects'
    templateUrl: 'projects/show.html'
    resolve: auth: redirectAuth

  .state 'projects.detail',
    url: '/:projectId'
    parent: 'projects'
    templateUrl: 'projects/detail.html'

  $locationProvider.html5Mode(true)
  $urlRouterProvider.otherwise '/projects'
]

redirectAuth = ($auth, $state, $translate, TodoToast) ->
  $auth.validateUser().catch (res) ->
    $state.go 'sign_in'
    TodoToast.error($translate('auth.error.must_authed'))

redirectAuthed = ($auth, $state, $location, I18n, TodoToast) ->
  $auth.validateUser()
    .then(() ->
      $state.go 'projects'
      TodoToast.error(I18n.t('auth.error.signed_in'))
    )
    .catch(() ->
      return
    )

angular.module('toDoApp').run ($rootScope, $state, $auth, I18n, TodoToast) ->
  $rootScope.$on 'auth:logout-success', (ev) ->
    $state.go 'sign_in'
    TodoToast.success(I18n.t('auth.success.sign_out'))
