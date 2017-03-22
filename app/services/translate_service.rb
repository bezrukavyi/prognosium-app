class TranslateService
  attr_reader :locale, :translations, :type

  def self.call(*args)
    service = new(*args)
    service.call
  end

  def initialize(params, type)
    @locale = params[:id].to_sym
    @translations = I18n.with_locale(@locale) do
      I18n.backend.send(:translations)[@locale]
    end
    @type = type
  end

  def call
    return translations if type.blank?
    send("#{type}_parse")
  end

  private

  def angular_parse
    translations.as_json(root: false).to_json.gsub(/%{(\w+)}/, '{{\1}}')
  end
end
