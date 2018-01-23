module Authenticable

  def current_family
    api_key = ApiKey.find_by_access_token(request.headers['Authorization'])
    @current_family ||= Family.find(api_key.family_id)
  end

  def authenticate_with_token!
    render json: {code: 401, errors: 'Not authenticated'},
           status: :unauthorized unless current_family.present?
  end

  def family_signed_in?
    current_family.present?
  end

end