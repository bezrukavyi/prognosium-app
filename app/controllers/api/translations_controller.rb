module Api
  class TranslationsController < ApplicationController
    respond_to :json

    def show
      @translations = TranslateService.call(params, :angular)
      render json: @translations
    end
  end
end
