class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[show edit update destroy]

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show; end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit; end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(friendship_params)
    if new_request? && @friendship.valid? && @friendship.save
      redirect_to users_path
    elsif !new_request?
      redirect_to users_path, alert: 'You have already sent a request'
    else
      render 'users/index'
    end
  end

  


  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    @friendship = Friendship.find(params[:id])
    redirect_to users_path if @friendship.status == false && @friendship.confirm_friend
  end

  def destroy
    @friendship = Friendship.where(user_id: [params[:id], current_user.id], request_friend_id: [current_user.id, params[:id]])

    if !@friendship.nil? && @friendship.each(&:destroy)
      redirect_to users_path
    else
      render 'users/index'
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def new_request?
    !current_user.request_exists?(User.find_by(id: params[:friendship][:request_friend_id]))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def friendship_params
    params.require(:friendship).permit(:user_id, :request_friend_id, :status)
  end
end
