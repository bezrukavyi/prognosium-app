module Support
  module Comments
    def delete_comment(comment)
      find("#delete-comment-#{comment.id}", visible: :hidden).click
    end

    def create_comment(task, options)
      within "#new-comment-#{task.id}" do
        fill_in 'title', with: options[:title]
        find('.create-comment').click
      end
    end

    def update_comment_title(comment, title)
      id = comment.id
      find("#edit-comment-#{id}", visible: :hidden).click
      within "#comment-form-#{id}" do
        fill_in 'title', with: title
      end
      find("#edit-comment-#{id}").click
    end

    def show_attachment(comment)
      find("#attachment-comment-#{comment.id}", visible: :hidden).click
    end
  end
end
