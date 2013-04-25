class PagesController < ApplicationController

  # GET /welcome
  # GET /pages/welcome
  def welcome
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end
end