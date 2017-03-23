class Api::UsersController < ApiController
  before_action :authenticated?

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    user.password_confirmation = user.password

    if user.save
      # Rails searches for a corresponding serializer. In this case, it will
      # find UserSerializer and use it to serialize `user`
      render json: user
    else
      # Returns error and a 422 - unprocessable_entity
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      user = User.find(params[:id])
      user.destroy

      # Returns HTTP 204 No Content, indicating that the server successfully
      # processed the request.
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound
      render :json => {}, :status => :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
