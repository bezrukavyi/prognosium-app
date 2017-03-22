class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def get_resource_from_auth_hash
    info = auth_hash['info']
    @resource = resource_class.find_or_initialize_by(email: info['email'])
    @resource.uid = auth_hash['uid']
    @resource.provider = auth_hash['provider']

    if @resource.new_record?
      @oauth_registration = true
      set_random_password
    end

    # sync user info with provider, update/generate auth token
    assign_provider_attrs(@resource, auth_hash)

    # assign any additional (whitelisted) attributes
    extra_params = whitelisted_params
    @resource.assign_attributes(extra_params) if extra_params

    @resource
  end
end
