class GithubQueryService
  attr_reader :language, :errors

  def initialize(p = {})
    @username = p[:username]
    @errors = []
  end

  def get_most_popular_language
    connect_to_api
    @repos = get_users_repos
    return '' if @errors.present?
    @languages = count_languages
    return '' if @errors.present?
    @language = most_popular_language
  end

  def connect_to_api
    connection = Faraday.new(url: "https://api.github.com")
    @response = connection.get "users/#{@username}/repos"
  end

  def parse_data
    JSON.parse(@response.body)
  end

  def get_users_repos
    @errors << "User Not Found" if parse_data.is_a?(Hash) && parse_data['message'] == "Not Found"
    parse_data
  end

  def count_languages
    languages = @repos.map{ |d| d['language'] }.compact
    @errors << 'No Repos for User' if languages.empty?
    languages
  end

  def most_popular_language
    languages_array = @languages.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total }
    popular = languages_array.max_by(&:last)
    popular[0]
  end
end