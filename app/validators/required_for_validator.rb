class RequiredForValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value.present?
    @object = object
    @attribute = attribute
    @value = value
    validate_for = options[:with].blank? ? 'special_values' : 'attribute'
    send("required_for_#{validate_for}")
  end

  private

  def required_for_special_values
    dependent_attributes = options.keys
    dependent_attributes.each do |dependent|
      dependent_value = @object.send(dependent)
      next if dependent_value.blank? || !options[dependent.to_sym].include?(dependent_value.to_sym)
      add_require_error
    end
  end

  def required_for_attribute
    dependent_value = @object.send(options[:with])
    return if dependent_value.blank?
    add_require_error
  end

  def add_require_error
    @object.errors.add(@attribute, I18n.t('validation.required'))
  end
end
