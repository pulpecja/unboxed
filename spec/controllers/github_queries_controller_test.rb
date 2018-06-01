require 'rails_helper'

RSpec.describe GithubQueriesController, type: :controller do
  let(:valid_params) { {username: 'pulpecja'} }
  let(:no_username_params) { {username: 'pulpecjapulpecja'} }
  let(:empty_params) { { username: '' } }
  let(:user_with_no_repos) { { username: 'emptyuser' } }

  it "GET #new" do
    get :new

    expect(response).to render_template :new
    assert_response :success
    expect(assigns(:github_query)).to be_a_new(GithubQuery)
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new github_query" do
        VCR.use_cassette("controllers/create") do
          expect {
            post :create, params: { github_query: valid_params }
          }.to change(GithubQuery, :count).by(1)
        end
      end

      it "assigns a newly created github_query as @github_query" do
        VCR.use_cassette("controllers/create") do
          post :create, params: { github_query: valid_params }
          expect(assigns(:github_query)).to be_a(GithubQuery)
          expect(assigns(:github_query)).to be_persisted
        end
      end

      it "redirects to the created github_query" do
        VCR.use_cassette("controllers/create") do
          post :create, params: { github_query: valid_params }
          expect(response).to redirect_to(GithubQuery.last)
        end
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved github_query as @github_query" do
        VCR.use_cassette("controllers/invalid_create") do
          expect{
            post :create, params: { github_query: no_username_params }
            expect(assigns(:github_query)).to be_a_new(GithubQuery)
          }.not_to change(GithubQuery, :count)
        end
      end

      it "re-renders the 'new' template" do
        VCR.use_cassette("controllers/invalid_create") do
          post :create, params: { github_query: no_username_params }
          expect(response).to render_template("new")
        end
      end

      it "generates errors" do
        VCR.use_cassette("controllers/invalid_create") do
          post :create, params: { github_query: no_username_params }
          expect(flash[:error]).to eq "User Not Found"
        end
      end
    end

    context "with empty params" do
      it "assigns a newly created but unsaved github_query as @github_query" do
        VCR.use_cassette("controllers/empty_create") do
          expect{
            post :create, params: { github_query: empty_params }
            expect(assigns(:github_query)).to be_a_new(GithubQuery)
          }.not_to change(GithubQuery, :count)
        end
      end

      it "re-renders the 'new' template" do
        VCR.use_cassette("controllers/empty_create") do
          post :create, params: { github_query: empty_params }
          expect(response).to render_template("new")
        end
      end

      it "generates errors" do
        VCR.use_cassette("controllers/empty_create") do
          post :create, params: { github_query: empty_params }
          expect(flash[:error]).to eq "User Not Found"
        end
      end
    end

    context "with empty user params" do
      it "assigns a newly created but unsaved github_query as @github_query" do
        VCR.use_cassette("controllers/empty_user_create") do
          post :create, params: { github_query: user_with_no_repos }
          expect(assigns(:github_query)).to be_a_new(GithubQuery)
        end
      end

      it "re-renders the 'new' template" do
        VCR.use_cassette("controllers/empty_user_create") do
          post :create, params: { github_query: user_with_no_repos }
          expect(response).to render_template("new")
        end
      end

      it "generates errors" do
        VCR.use_cassette("controllers/empty_user_create") do
          post :create, params: { github_query: user_with_no_repos }
          expect(flash[:error]).to eq "No Repos for User"
        end
      end
    end
  end
end