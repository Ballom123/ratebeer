class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[ show edit update destroy ]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @ids = current_user.beer_clubs.pluck(:id)
    @beer_clubs = BeerClub.where.not(id: @ids)
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user_id = current_user.id

    if @membership.save
      redirect_to user_path current_user
    else
      @beer_clubs = BeerClub.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to memberships_url, notice: "Membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
