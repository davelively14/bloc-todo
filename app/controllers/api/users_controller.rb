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

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
