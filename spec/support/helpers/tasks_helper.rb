require_relative 'projects_helper'
require_relative 'wait_ajax_helper'

module Support
  module Tasks
    include Projects

    def go_to_task(task)
      visit "projects/#{task.project.id}/tasks/#{task.id}"
      wait_ajax
    end

    def create_task(form_id, options)
      file_path = "#{Rails.root}/spec/fixtures/#{options[:initial_data]}"
      within "##{form_id}" do
        fill_in 'title', with: options[:title]
        attach_file 'file', file_path, visible: :hidden
      end
      wait_ajax
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
