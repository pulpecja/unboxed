class GithubQueriesController < ApplicationController
  before_action :set_github_query, only: [:show]

  def show
  end

  def new
    @github_query = GithubQuery.new
  end

  def create
    @github_query = GithubQuery.new(github_query_params)

    query = GithubQueryService.new(params[:github_query])
    response = query.get_most_popular_language

    if query.errors.present?
      flash[:error] = query.errors.join(', ')
      render action: 'new'
    else
      @github_query.language = response

      if @github_query.save
        redirect_to @github_query
      else
        render action: 'new'
      end
    end
  end

  private
  def set_github_query
    @github_query = GithubQuery.find(params[:id])
  end

  def github_query_params
    params.require(:github_query).permit(:username)
  end
end
