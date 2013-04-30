class AdventuresController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :new, :create, :shared]
  before_filter :authenticate_user_or_welcome!, :only => [:index]
  before_filter :find_adventure, :except => [:index, :shared, :new, :create]
  before_filter :find_adventure_by_muddle, :except => [:index, :show, :new, :create] 
  before_filter :restrict_access_to_author, :only => [:edit, :show, :update, :destroy] 
  before_filter :restrict_access_to_respondent_or_token, :only => [:shared] 

  # GET /adventures
  # GET /adventures.json
  def index
    if current_user
      @adventures = current_user.adventures 
    else
      @adventures = []
    end

    @adventure = Adventure.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adventures }
    end
  end

  # GET /adventure/1
  # GET /adventure/1.json
  def show
    @adventure ||= Adventure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @adventure }
    end
  end

  # GET /m/a23?token=1ad2
  # GET /m/a23?token=1ad2.json
  def shared 
    @adventure ||= Adventure.find_by_muddle(params[:muddle])
    render :show
  end

  # GET /adventures/new
  # GET /adventures/new.json
  def new
    @adventure = Adventure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adventure }
    end
  end

  # GET /adventures/1/edit
  def edit
    @adventure ||= Adventure.find(params[:id])
  end

  # POST /adventures
  # POST /adventures.json
  def create
    @adventure = current_user.authored_adventures.build(params[:adventure])

    respond_to do |format|
      if @adventure.save
        # create a response for the user
        @response = Response.where(:user_id => current_user.id, :adventure_id => @adventure.id).first_or_create!

        format.html { redirect_to share_adventure_path(:muddle => @adventure.muddle), notice: 'Adventure was successfully created.' }
        format.json { render json: @adventure, status: :created, location: @adventure }
      else
        format.html { render action: "new" }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adventures/1
  # PUT /adventures/1.json
  def update
    @adventure ||= Adventure.find(params[:id])

    respond_to do |format|
      if @adventure.update_attributes(params[:adventure])
        format.html { redirect_to share_adventure_path(:muddle => @adventure.muddle), notice: 'Adventure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adventures/1
  # DELETE /adventures/1.json
  def destroy
    @adventure ||= Adventure.find(params[:id])
    @adventure.destroy

    respond_to do |format|
      format.html { redirect_to adventures_url }
      format.json { head :no_content }
    end
  end

  # POST /adventures/heart
  # POST /adventures/heart.json
  def heart 
    @adventure ||= Adventure.find(params[:id])
    # @response = current_user.responses.find_by_adventure(@adventure)
    @response = Response.where(:user_id => current_user.id, :adventure_id => @adventure.id).first_or_create

    respond_to do |format|
      if @response.heart!
        format.html { redirect_to share_adventure_path(:muddle => @adventure.muddle), notice: 'Adventure was hearted successfully ' + helpers.pluralize(@response.hearts_count, 'time') + '.' }
        format.json { render json: @adventure, status: :created, location: @adventure }
      else
        format.html { render action: "new" }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end    
  end

  private 

    def find_adventure
      @adventure ||= Adventure.find(params[:id])
    end

    def find_adventure_by_muddle
      muddle = params[:id] ? params[:id] : params[:muddle] # rails defaults to using id sometimes
      @adventure ||= Adventure.find_by_muddle(muddle)
    end

    def restrict_access_to_author
      # TODO: replace with cancan
      unless @adventure.author_id == current_user.id
        raise ActionController::RoutingError.new('Not Found') # purposely fake a 404 for unauthorized
      end
    end

    def restrict_access_to_respondent_or_token
      # TODO: replace with cancan
      unless (@adventure.token == params[:token]) || (current_user && Response.exists?(:user_id => current_user.id, :adventure_id => @adventure.id))
        raise ActionController::RoutingError.new('Not Found') # purposely fake a 404 for unauthorized
      end
    end

end
