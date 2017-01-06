require 'spec_helper'
RSpec.describe PinsController do

	before(:each) do	
		@user = FactoryGirl.create(:user_with_boards)
		login(@user)
		@board = @user.boards.first
		@board_pinner = BoardPinner.create(user: @user, board: FactoryGirl.create(:board))
		@pin = FactoryGirl.create(:pin)
	end
	
	after(:each) do
		@pin.destroy
		if !@user.destroyed?
			@user.pinnings.destroy_all
			@user.boards.destroy_all
			@user.pins.destroy_all
			@user.destroy
		end
	end


	describe "GET index" do
		it 'renders the index template' do
			get :index
			expect(response).to render_template("pins/index")
		end
		
		it 'populates @pins with all pins' do
			get :index
			expect(assigns[:pins]).to eq(Pin.all)
		end
		
		it 'redirects to Login when loggged out' do
			logout(@user)
			get :index
			expect(response).to redirect_to(:login)
		end
	end
  describe "GET new" do
	it 'responds with successfully' do
	  get :new
	  expect(response.success?).to be(true)
	end
	
	it 'renders the new view' do
	  get :new      
	  expect(response).to render_template(:new)
	end
	
	it 'assigns an instance variable to a new pin' do
	  get :new
	  expect(assigns(:pin)).to be_a_new(Pin)
	end
	
	it 'redirects to Login when logged out' do
		logout(@user)
		get :new
		expect(response).to redirect_to(:login)
	end
	
	it 'assigns @pinnable_boards to all pinnable boards' do
		get :new
		expect(assigns(:pinnable_boards)).to eq(@pinnable_boards)
	end
  end
  
  describe "POST create" do
    before(:each) do
      @pin_hash = { 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: "rails"}    
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with a redirect' do
      post :create, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end
    
    it 'creates a pin' do
      post :create, pin: @pin_hash  
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end
    
    it 'redirects to the show view' do
      post :create, pin: @pin_hash
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end
    
    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(response).to render_template(:new)
    end
    
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(assigns[:errors].present?).to be(true)
    end    
    
	it 'redirects to Login when logged out' do
		logout(@user)
		post :create, pin: @pin_hash
		expect(response).to redirect_to(:login)
	end
	
	it 'pins to a board for which the user is a board_pinner' do
		@pin_hash[:pinnings_attributes] = []
		board = @board_pinner.board
		@pin_hash[:pinnings_attributes] << {board_id: board.id, user_id: @user.id}
		post :create, pin: @pin_hash
		pinning = BoardPinner.where("user_id=? AND board_id=?", @user.id, board.id)
		expect(pinning.present?).to be(true)
		if pinning.present?
			pinning.destroy_all
		end
	end

  end
  describe "GET edit" do
	#before(:each) do
	#	@pin = Pin.find(1)
	#end
	it 'responds with successfully' do
      get :edit, id: @pin.id
      expect(response.success?).to be(true)
    end
	it 'renders the edit view' do
      get :edit, id: @pin.id     
      expect(response).to render_template(:edit)
    end
	 it 'assigns an instance variable called @pin to the pin with appropriate id' do
      get :edit, id: @pin.id   
      expect(assigns(:pin)).to eq(@pin)
    end
	it 'redirects to Login when logged out' do
		logout(@user)
		get :edit, id: @pin.id
		expect(response).to redirect_to(:login)
	end
  end
  
  describe "PUT update" do
	before(:each) do	
		#@pin = Pin.find(2)
		@pin_hash = { 
        title: "Rails Cheatsheet",
		url: "http://rails-cheat.com",
		text: "A great tool for beginning developers" ,
        slug:  "rails-cheat",
        category_id: "rails",
		user_id: @user.id,
		}
		@error_hash = {
		title: nil
		}
	end
	it 'responds with successfully' do
      put :update, id: @pin.id, pin: @pin_hash
      expect(response).to redirect_to("/pins/#{@pin.id}")
    end
	it 'updates a pin' do
		put :update, id: @pin.id, pin: @pin_hash
	expect(Pin.find(@pin.id).title).to eq(@pin_hash[:title])
	end
	it 'redirects to show view' do
	 put :update, id: @pin.id, pin: @pin_hash
	expect(response).to redirect_to(pin_url(assigns(:pin)))
	end
	it 'assigns an @errors instance vairable' do
	 put :update, id: @pin.id, pin: @error_hash
	 expect(assigns[:errors].present?).to be(true)
	end
	it 'renders the edit view' do
	 put :update, id: @pin.id, pin: @error_hash
	 expect(response).to render_template(:edit)
	 end
	 it 'redirects to Login when logged out' do
		logout(@user)
		put :update, id: @pin.id, pin: @pin_hash
		expect(response).to redirect_to(:login)
	end
  end
  
  describe "POST repin" do
	before(:each) do	
		@user = FactoryGirl.create(:user_with_boards)
		login(@user)
		@pin = FactoryGirl.create(:pin)
	end
	
	after(:each) do
		pin = Pin.find_by_slug("rails-wizard")
		if !pin.nil?
			pin.destroy
		end
		logout(@user)
	end
	
	it 'responds with a redirect' do
		post :repin, id: @pin.id, pin: {pinning: {user_id: @user.id}}
		expect(response.redirect?).to be (true)
	end
	
	it 'creates a user.pin' do
		post :repin, id: @pin.id, pin: {pinning: {user_id: @user.id}}
		expect(assigns(:pin)).to eq(Pin.find(@pin.id))
	end
	
	it 'redirects to the user show page' do
		post :repin, id: @pin.id, pin: {pinning: {user_id: @user.id}}
		expect(response).to redirect_to(user_path(@user))
	end
	
	it 'creates a pinning to a board on which the user is a board_pinner' do
		@pin_hash = {
			title: @pin.title,
			url: @pin.url,
			slug: @pin.slug,
			text: @pin.text,
			category_id: @pin.category_id,
		}
		board = @board_pinner.board
		@pin_hash[:pinning] = {board_id: board.id}
		post :repin, id: @pin.id, pin: @pin_hash
		pinning = Pinning.where("board_id=?", @board.id)
		expect(pinning.present?).to be(true)
		if pinnng.present?
			pinning.destroy_all
		end
	end
end
end

