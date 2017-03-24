module Support
  module Main
    def update_title(title, type)
      type = type.to_s
      find("#edit-#{type}").click
      within "##{type}-form" do
        fill_in 'title-field', with: title
      end
      find("#edit-#{type}").click
    end
  end
end
