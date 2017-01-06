class PinsController < ApplicationController
	before_action :require_login, except: [:show, :show_by_name]
  
  def index
    @pins = Pin.all
  end
  
  def new
	@pin = Pin.new
	@pin.pinnings.build
	render :new
  end
  
  def create
	@pin = current_user.pins.new(pin_params)
	if @pin.valid?
		@pin.save
		redirect_to pin_path(@pin)
	else
		@errors = @pin.errors
		render :new
	end
  end
  
  def edit
	@pin = Pin.find(params[:id])
	render :edit
  end
  
  def update
	@pin = Pin.find(params[:id])
	if @pin.update_attributes(pin_params)
		redirect_to pin_path(@pin)
	else
		@errors = @pin.errors
		render :edit
	end
  end
    
  def show
	@pin = Pin.find(params[:id])
	@users = @pin.users
	@pins = current_user.pins
  end
  
  def show_by_name
	@pin = Pin.find_by_slug(params[:slug])
	@users = @pin.users
	@user = current_user
	render :show
  end
  
  def destroy
	@pin = Pin.find(params[:id])
	if !@pin.destroy
		@pin.destroy
		format.html{redirect_to action: :index, notice: "Thee pin was successfully deleted!"}
	end
  end
  
  def repin
	@pin = Pin.find(params[:id])
	@pin.pinnings.create(user: current_user)
	redirect_to user_path(current_user)
  end
  private
	def pin_params
		params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
	end
end