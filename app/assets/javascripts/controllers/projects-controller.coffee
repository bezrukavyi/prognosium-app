ProjectsController = (Project, $stateParams, $state, $filter, I18n, TodoToast, Access) ->
  ctrl = @
  ctrl.currentProject = null
  ctrl.all = null

  ctrl.projectId = $state.params.projectId

  ctrl.date = new Date()
  ctrl.minDate = new Date(
    ctrl.date.getFullYear(),
    ctrl.date.getMonth(),
    ctrl.date.getDate()
  )

  ctrl.index = () ->
    Project.index().$promise.then (
      (response) ->
        ctrl.all = response
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.show = (options) ->
    Project.get(options).$promise.then (
      (response) ->
        if response.completed_at
          response.completed_at = new Date(response.completed_at)
        ctrl.currentProject = response
      ), (response) ->
        ctrl.currentProject = null
        TodoToast.error(response.data.error)

  ctrl.create = () ->
    options = { title: I18n.t('project.default_title') }
    return unless Access.can('request')
    Access.lock('request')
    Project.create(options).$promise.then (
      (response) ->
        ctrl.all.push(response)
        ctrl.currentProject = response
        $state.go('projects.detail', projectId: response.id)
        TodoToast.success(I18n.t('project.success.created'))
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.edit = (form) ->
    project = ctrl.currentProject
    return true if form.$invalid
    ctrl.update(form, project) if form.edited == true
    form.edited = !form.edited

  ctrl.update = (form, project) ->
    return unless form.$valid
    Project.update(project).$promise.then(null, (response) ->
      TodoToast.error(response.data.error)
    )

  ctrl.delete = (project) ->
    return unless Access.can('request')
    Access.lock('request')
    Project.delete(id: project.id).$promise.then (
      (response) ->
        ctrl.delete_from_list(ctrl.currentProject)
        ctrl.currentProject = null
        TodoToast.success(I18n.t('project.success.deleted', title: response.title))
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.itsCurrentProject = (project) ->
    return false unless ctrl.currentProject
    ctrl.currentProject.id == project.id

  ctrl.delete_from_list = (project) ->
    index = ctrl.all.indexOf($filter('filter')(ctrl.all, id: project.id)[0])
    ctrl.all.splice(index, 1) if (index != -1)

  ctrl.index()
  ctrl.show(id: ctrl.projectId) if ctrl.projectId

  return

angular.module('toDoApp').controller 'ProjectsController', [
  'Project',
  '$stateParams',
  '$state',
  '$filter',
  'I18n',
  'TodoToast',
  'Access',
  ProjectsController
]
