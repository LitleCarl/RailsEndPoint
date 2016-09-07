class FloorsController < ApplicationController

  def index
  end

  def show
    @floor_id = params[:id]
  end

  def new
  end

  def create
    @response, @floor = Floor.create_with_options_for_api(params)
  end
end
