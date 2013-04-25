class MomentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :new, :create, :shared]
  before_filter :authenticate_user_or_welcome!, :only => [:index]
  before_filter :find_moment, :except => [:index, :shared, :new, :create]
  before_filter :find_moment_by_muddle, :except => [:index, :show, :new, :create] 
  before_filter :restrict_access_to_author, :only => [:edit, :show, :update, :destroy] 
  before_filter :restrict_access_to_respondent_or_token, :only => [:shared] 

  # GET /moments
  # GET /moments.json
  def index
    if current_user
      @moments = current_user.moments 
    else
      @moments = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @moments }
    end
  end

  # GET /moment/1
  # GET /moment/1.json
  def show
    @moment ||= Moment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @moment }
    end
  end

  # GET /m/a23?token=1ad2
  # GET /m/a23?token=1ad2.json
  def shared 
    @moment ||= Moment.find_by_muddle(params[:muddle])
    render :show
  end

  # GET /moments/new
  # GET /moments/new.json
  def new
    @moment = Moment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @moment }
    end
  end

  # GET /moments/1/edit
  def edit
    @moment ||= Moment.find(params[:id])
  end

  # POST /moments
  # POST /moments.json
  def create
    @moment = current_user.authored_moments.build(params[:moment])

    respond_to do |format|
      if @moment.save
        # create a response for the user
        @response = Response.where(:user_id => current_user.id, :moment_id => @moment.id).first_or_create!

        format.html { redirect_to share_moment_path(:muddle => @moment.muddle), notice: 'Moment was successfully created.' }
        format.json { render json: @moment, status: :created, location: @moment }
      else
        format.html { render action: "new" }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /moments/1
  # PUT /moments/1.json
  def update
    @moment ||= Moment.find(params[:id])

    respond_to do |format|
      if @moment.update_attributes(params[:moment])
        format.html { redirect_to share_moment_path(:muddle => @moment.muddle), notice: 'Moment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moments/1
  # DELETE /moments/1.json
  def destroy
    @moment ||= Moment.find(params[:id])
    @moment.destroy

    respond_to do |format|
      format.html { redirect_to moments_url }
      format.json { head :no_content }
    end
  end

  # POST /moments/heart
  # POST /moments/heart.json
  def heart 
    @moment ||= Moment.find(params[:id])
    # @response = current_user.responses.find_by_moment(@moment)
    @response = Response.where(:user_id => current_user.id, :moment_id => @moment.id).first_or_create

    respond_to do |format|
      if @response.heart!
        format.html { redirect_to share_moment_path(:muddle => @moment.muddle), notice: 'Moment was hearted successfully ' + helpers.pluralize(@response.hearts_count, 'time') + '.' }
        format.json { render json: @moment, status: :created, location: @moment }
      else
        format.html { render action: "new" }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end    
  end

  private 

    def find_moment
      @moment ||= Moment.find(params[:id])
    end

    def find_moment_by_muddle
      muddle = params[:id] ? params[:id] : params[:muddle] # rails defaults to using id sometimes
      @moment ||= Moment.find_by_muddle(muddle)
    end

    def restrict_access_to_author
      # TODO: replace with cancan
      unless @moment.author_id == current_user.id
        raise ActionController::RoutingError.new('Not Found') # purposely fake a 404 for unauthorized
      end
    end

    def restrict_access_to_respondent_or_token
      # TODO: replace with cancan
      unless (@moment.token == params[:token]) || (current_user && Response.exists?(:user_id => current_user.id, :moment_id => @moment.id))
        raise ActionController::RoutingError.new('Not Found') # purposely fake a 404 for unauthorized
      end
    end

end
