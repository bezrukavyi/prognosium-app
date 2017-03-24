require_relative 'projects_helper'

module Support
  module Tasks
    include Projects

    def create_task(form_id, options)
      within "##{form_id}" do
        fill_in 'title', with: options[:title]
      end
      find('#create-task').click
    end

    def delete_task(task = nil)
      if task
        find("#delete-task-#{task.id}", visible: :hidden).click
      else
        find('#delete-task').click
      end
    end

    def update_task_title(task, title)
      id = task.id
      find("#edit-task-#{id}", visible: :hidden).click
      within "#task-form-#{id}" do
        fill_in 'title', with: title
      end
      find("#edit-task-#{id}").click
    end

    def task_checkbox(task)
      find("#task-checkbox-#{task.id}")
    end

    def checkbox_state(task)
      task_checkbox(task)['aria-checked']
    end

    def show_comments(task)
      find("#show-comments-#{task.id}", visible: :hidden).click
    end

    def choose_task(task)
      choose_project(task.project)
      find("#show-task-#{task.id}", visible: :hidden).click
      wait_ajax
    end

    def back_to_project
      find('#back-task').click
    end
  end
end
