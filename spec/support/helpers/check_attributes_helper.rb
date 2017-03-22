module Support
  module CheckAttributes
    def check_title(objects, name = :title, exist = true)
      objects = check_objects(objects)
      objects.each do |object|
        exist_value(object.send(name), exist)
      end
    end

    def check_hidden_title(objects, name = :title, exist = true)
      objects = check_objects(objects)
      objects.each do |object|
        exist_hidden_value(object.send(name), exist)
      end
    end

    def exist_value(value, exist)
      if exist
        expect(page).to have_content(value)
      else
        expect(page).to have_no_content(value)
      end
    end

    def exist_hidden_value(value, exist)
      options = { text: value, visible: :hidden }
      if exist
        expect(page).to have_css('span.hidden', options)
      else
        expect(page).to have_no_css('span.hidden', options)
      end
    end

    private
    def check_objects(objects)
      objects.respond_to?(:each) ? objects : [objects]
    end
  end
end
