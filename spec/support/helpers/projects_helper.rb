require_relative 'wait_ajax_helper'

module Support
  module Projects
    include Support::WaitAjax

    def choose_project(project)
      first('.project-link', text: project.title).click
      wait_ajax
    end

    def delete_project
      find('#delete-project').click
    end

    def create_project
      first(:button, 'New project').click
    end

    def update_project_title(title)
      find('#edit-project').click
      within '#project-form' do
        fill_in 'title-field', with: title
      end
      find('#edit-project').click
    end

    def completed_at_project(project, time)
      find('#deadline-project').click
      find("[id*='#{time.year}-#{time.month - 1}-#{time.day}']").click
    end

    def check_completed_at(date, exist = true)
      value = date.strftime('%d/%m/%y')
      if exist
        expect(page).to have_content(value)
      else
        expect(page).to have_no_content(value)
      end
    end
  end
end
