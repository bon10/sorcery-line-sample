class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    else
      begin
        sorcery_fetch_user_hash(provider)
        create_user(provider)
        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
      rescue
        redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
      end
    end
  end

  private

  # id_tokenからemailを取得
  # 申請していない場合は取得できない
  def create_user(provider_name)
    attrs = user_attrs(@provider.user_info_mapping, @user_hash)
    id_token = @access_token.params['id_token']
    id_token_payload = JWT.decode(id_token,@provider.secret)
    Rails.logger.info id_token_payload.inspect
    email = id_token_payload.first['email']
    attrs['email'] = email || 'example@test-mail.jp'

    @user = user_class.create_from_provider(provider_name, @user_hash[:uid], attrs)
  end

  def auth_params
    params.permit(:code, :provider, :state)
  end
end
