require 'spec_helper'

describe GithubQueryService do
  describe "#create" do
    let(:valid_params)       { { username: 'pulpecja' } }
    let(:no_username_params) { { username: 'pulpecjapulpecja' } }
    let(:empty_params)       { { username: '' } }
    let(:empty_user_params)  { { username: 'emptyuser' } }

    describe "passing valid parameters" do
      it "connects successfully" do
        VCR.use_cassette("services/valid_connect") do
          subject = GithubQueryService.new(valid_params)
          expect(subject.connect_to_api).to be_success
        end
      end

      it "gets proper language" do
        VCR.use_cassette("services/valid_connect") do
          subject = GithubQueryService.new(valid_params)
          expect(subject.get_most_popular_language).to eq 'Ruby'
        end
      end
    end

    describe "passing invalid parameters" do
      it "gets no language" do
        VCR.use_cassette("services/invalid_connect") do
          subject = GithubQueryService.new(no_username_params)
          expect(subject.get_most_popular_language).to eq ''
        end
      end

      it "returns no errors" do
        VCR.use_cassette("services/invalid_connect") do
          subject = GithubQueryService.new(no_username_params)
          expect(subject.errors).to eq []
        end
      end
    end

    describe "passing empty parameters" do
      it "gets no language" do
        VCR.use_cassette("services/empty_connect") do
          subject = GithubQueryService.new(empty_params)
          expect(subject.get_most_popular_language).to eq ''
        end
      end

      it "returns errors" do
        VCR.use_cassette("services/empty_connect") do
          subject = GithubQueryService.new(empty_params)
          subject.get_most_popular_language
          expect(subject.errors).to eq ['User Not Found']
        end
      end
    end

    describe "passing parameters of user with no repos" do
      it "gets no language" do
        VCR.use_cassette("services/empty_user_connect") do
          subject = GithubQueryService.new(empty_user_params)
          expect(subject.get_most_popular_language).to eq ''
        end
      end

      it "returns errors" do
        VCR.use_cassette("services/empty_user_connect") do
          subject = GithubQueryService.new(empty_user_params)
          subject.get_most_popular_language
          expect(subject.errors).to eq ['No Repos for User']
        end
      end
    end
  end
end