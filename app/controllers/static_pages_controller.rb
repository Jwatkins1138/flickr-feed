class StaticPagesController < ApplicationController

  require 'flickr'
  attr_accessor :user, :page

  rescue_from Flickr::FailedResponse, with: :redirect

  def redirect
    redirect_to root_path, notice: 'invalid entry'
  end

  def search
    @user = search_params[:user]
  end

  def page
    @page = page_params[:value].to_i
  end

  def home
    if params.has_key?(:page)
      self.page
    else
      @page = 0
    end
    @flickr = Flickr.new 'c3b24c4771841ae549d139cbc32cb27f', 'e04191fd639dc0d5'
    if params.has_key?(:search)
      self.search
    else  
      @user = '195812980@N04'
    end  
    @urls = [[]]
    @list = @flickr.people.getPublicPhotos :user_id => @user
    i = 0
    c = 0
    @urls[i] = []
    @list.each do |l|
      @id = l.id
      @secret = l.secret
      @info = @flickr.photos.getInfo :photo_id => @id, :secret => @secret
      @url = Flickr.url(@info)
      @urls[i].push(@url)
      c += 1
      if c >= 9
        i += 1  
        c = 0
        @urls[i] = []
      end  
    end 
  end

  private

  def search_params
    params.require(:search).permit(:user)
  end

  def page_params
    params.require(:page).permit(:value)
  end

end
