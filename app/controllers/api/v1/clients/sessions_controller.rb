class Api::V1::Clients::SessionsController < DeviseTokenAuth::SessionsController
  before_action :authenticate_api_v1_client!, only: [:destroy]
  wrap_parameters Client, include: [:email, :password]

  def create
    raise ApiError::ErrorValidate unless resource_params[:email].present? && resource_params[:password].present?

    @resource = Client.find_by email: resource_params[:email]
    return render_email_not_exist unless @resource.present?

    valid_password = @resource.valid_password?(resource_params[:password])
    return render_password_incorrect unless valid_password

    token = @resource.create_token
    @resource.save
    sign_in(:client, @resource, store: false, bypass: false)
    json_response(:ok, ClientSerializer.new(@resource, {params: {token: token}}).to_h)
  end

  def destroy
    client = @token.client
    @token.clear!
    unless current_api_v1_client && client && current_api_v1_client.tokens[client]
      raise ApiError::ErrorSignOut
    end

    current_api_v1_client.tokens.delete(client)
    current_api_v1_client.save!
    json_response(:no_content)
  end

  private
  def resource_params
    params.permit(*params_for_resource(:sign_in), :client_id)
  end

  def render_password_incorrect
    handle_error! I18n.t("model.company_admin.sign_in.password_incorrect")
  end

  def render_account_not_confirm
    handle_error! I18n.t("model.company_admin.sign_in.account_not_confirm")
  end

  def render_company_not_approved
    handle_error! I18n.t("model.company.errors.not_approved")
  end

  def render_email_not_exist
    handle_error! I18n.t("model.company_admin.sign_in.email_not_exist")
  end
end