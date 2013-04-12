class MomentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :new, :create]
  before_filter :find_moment_by_muddle, :except => [:index, :new, :create] 
  before_filter :restrict_access_to_author, :only => [:edit, :update, :destroy] 
  before_filter :restrict_access_to_author_or_token, :only => [:show] 

  # GET /moments
  # GET /moments.json
  def index
    @moments = Moment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @moments }
    end
  end

  # GET /m/a23?t=1ad2
  # GET /m/a23?t=1ad2.json
  def show
    @moment ||= Moment.find_by_muddle(params[:muddle])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @moment }
    end
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
    @moment ||= Moment.find_by_muddle(params[:id])
  end

  # POST /moments
  # POST /moments.json
  def create
    @moment = Moment.new(params[:moment])
    @moment.author_id = current_user.id

    # Alternative?: current_user.moments.create(params[:app])

    respond_to do |format|
      if @moment.save
        format.html { redirect_to muddle_moment_path(@moment), notice: 'Moment was successfully created.' }
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
    @moment ||= Moment.find_by_muddle(params[:id])

    respond_to do |format|
      if @moment.update_attributes(params[:moment])
        format.html { redirect_to muddle_moment_path(@moment), notice: 'Moment was successfully updated.' }
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
    @moment ||= Moment.find_by_muddle(params[:id])
    @moment.destroy

    respond_to do |format|
      format.html { redirect_to moments_url }
      format.json { head :no_content }
    end
  end

  private 

    def find_moment_by_muddle
      muddle = params[:id] ? params[:id] : params[:muddle] # rails defaults to using id sometimes
      @moment ||= Moment.find_by_muddle(muddle)
    end

    def restrict_access_to_author
      unless @moment.author_id == current_user.id
        raise ActionController::RoutingError.new('Not Found') # purposely fake a 404 for unauthorized
      end
    end

    def restrict_access_to_author_or_token
      unless (@moment.author_id == current_user.id) || (@moment.token == params[:token])
        raise ActionController::RoutingError.new('Not Found') # purposely fake a 404 for unauthorized
      end
    end

end
