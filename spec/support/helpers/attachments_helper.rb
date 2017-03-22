require_relative 'wait_ajax_helper'

module Support
  module Attachments
    include Support::WaitAjax

    def check_attachment_attrs(attachment, exist = true)
      metadata = attachment.file.metadata
      path = metadata ? metadata['url'] : attachment.file.url
      if exist
        expect(page).to have_content(attachment.name.upcase)
        expect(page).to have_selector(:css, "a[href='#{path}']")
      else
        expect(page).to have_no_content(attachment.name.upcase)
        expect(page).to have_no_selector(:css, "a[href='#{path}']")
      end
    end

    def delete_attachment(attachment)
      find("#delete-attachment-#{attachment.id}").click
    end

    def attachment_upload(options, object)
      within "#attachment-upload-#{object.id}" do
        attach_file 'file', File.absolute_path(options[:file].path), visible: :hidden
      end
      wait_ajax
    end
  end
end
