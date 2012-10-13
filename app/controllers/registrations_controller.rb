#coding: utf-8
class RegistrationsController < Devise::RegistrationsController
  before_filter :skip_default_actions, only:[:destroy, :edit, :update, :cancel]

  def create
    qiita = Qiita.new url_name: params[:registration][:qiita_user], password: params[:qiita_pass]

    auth = session["devise.facebook_data"]
    user = User.create(#name: auth.extra.raw_info.name,
                       provider: auth[:provider],
                       uid: auth[:uid],
                       email: auth[:email],
                       password: "wantedly0",#need delete
                       password_confirmation: "wantedly0",#need delete
                       qiita_user: params[:registration][:qiita_user],
                       qiita_token: qiita.token)
    sign_in_and_redirect user, :event => :authentication
  rescue  Qiita::Unauthorized => e
    redirect_to new_user_registration_path
  end

  private
  def skip_default_actions
    redirect_to root_path
  end
end
