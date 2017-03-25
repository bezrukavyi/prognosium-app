TasksController = (Task, TodoToast, I18n, Access, $state, $filter) ->
  ctrl = @
  ctrl.currentTask = null

  ctrl.editedTask = null

  ctrl.taskId = $state.params.taskId
  ctrl.projectId = $state.params.projectId

  ctrl.new = { project_id: null, title: null }

  ctrl.show = (options) ->
    Task.default.get(options).$promise.then (
      (response) ->
        ctrl.currentTask = response
      ), (response) ->
        ctrl.currentTask = null
        TodoToast.error(response.data.error)
        ctrl.toProject()

  ctrl.create = (form, project, file) ->
    return if !file || form.$invalid || !Access.can('request')
    ctrl.new.project_id = project.id
    Access.lock('request')
    Task.upload(file, ctrl.new).then (
      (response) ->
        project.tasks.push(response.data)
        ctrl.resetNew(form)
        ctrl.toTask(response.data)
        TodoToast.success(I18n.t('task.success.created', title: response.data.title))
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.edit = (form, task) ->
    return if form.$invalid
    ctrl.update(form, task) if form.edited == true
    form.edited = !form.edited

  ctrl.update = (form, task) ->
    return if form.$invalid
    Task.default.update(task).$promise.then(null, (response) ->
      TodoToast.error(response.data.error)
    )

  ctrl.delete = (task, project) ->
    return unless Access.can('request')
    Access.lock('request')
    Task.default.delete(task).$promise.then (
      (response) ->
        index = project.tasks.indexOf($filter('filter')(project.tasks, id: task.id)[0])
        project.tasks.splice(index, 1) if (index != -1)
        TodoToast.success(I18n.t('task.success.deleted', title: response.title))
        ctrl.toProject()
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.upload = (project, task, file) ->
    return unless file && Access.can('request')
    options = { project_id: project.id, id: task.id }
    Access.lock('request')
    Task.upload(file, options, 'put').then (
      (response) ->
        Object.assign(task, response.data)
        TodoToast.success(I18n.t('data.success.updated'))
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.resetNew = (form) ->
    form.$setPristine()
    form.$setUntouched()
    ctrl.new = {}

  ctrl.sortableOptions =
    cursor: 'move',
    stop:  (event, ui) ->
      task = ui.item.scope().task
      task.position = ui.item.index() + 1
      Task.default.update(task).$promise.then(null, (response) ->
        TodoToast.error(response.data.error)
      )

  ctrl.show(id: ctrl.taskId, project_id: ctrl.projectId) if ctrl.taskId && ctrl.projectId

  ctrl.toProject = () ->
    $state.go('projects.detail', $state.params)

  ctrl.toTask = (data) ->
    $state.go('projects.task', projectId: data.project_id, taskId: data.id)

  return


angular.module('toDoApp').controller 'TasksController', [
  'Task',
  'TodoToast',
  'I18n',
  'Access',
  '$state',
  '$filter',
  TasksController
]
