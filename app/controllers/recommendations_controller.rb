class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized
  before_action :skip_pundit?

  def index
    # Index should match 5 recommendations according to Location and InterestsCategory picked. How to play interest?
    # Save interest picked? How? request.cookies? (como lo capturo?)
    # interestPicks = []

    @recommendations = policy_scope(Recommendation).joins(user: :interests).where('interests.title' => params[:interests]).limit(4)
    @bookmark = Bookmark.new
    @list = []

    Match.matcher(current_user, params[:location]).each do |match|
      if !match[0].recommendations.empty?
        match[0].recommendations.each do |recommendation|
        @list << recommendation
        end
      end
    end

    @list = @list.group_by { |recommendation| recommendation.category }

    # params = {
    #   location: "Recoleta",
    #   category: ["Sports", "Gaming"]
    # }
    # raise
    # search recommendations by city and categories (NOT FINISHED)
    # @recommendations = policy_scope(Recommendation).where(location: params[:location]).limit(4)
  end

    # search recommendations by city and categories (NOT FINISHED, add location with geocoding GEM)

  def destroy
    @recommendation = Recommendation.find(params[:id])
    authorize @recommendation
      if @recommendation.destroy
      flash[:notice] = "Deleted from recommendations"
      redirect_back(fallback_location: root_path)
      else
      flash[:notice] = "Couldn't delete recommendation"
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def new
    @recommendation = current_user.recommendations.build
    authorize @recommendation
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user = current_user
    @recommendation.category = params[:recommendation][:category].join(",")
    authorize @recommendation
    if @recommendation.save
      redirect_to recommendation_path(@recommendation)
    else
      render 'new'
      raise
    end
  end

  def show
    @recommendation = Recommendation.find(params[:id])
    authorize @recommendation
    @bookmark = Bookmark.new
    authorize @bookmark
  end

  private

  def recommendation_params
    # params.require(:recommendation).permit(:title, :description, :location, :price_range, :reservation, :duration, :user_id)
  end
end
