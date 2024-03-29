class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if !@user.nil? && @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = {
        provider: request.env["omniauth.auth"].provider,
        uid: request.env["omniauth.auth"].uid,
        email: request.env["omniauth.auth"].info.email
      }
      redirect_to new_user_registration_url
    end
  end
end
