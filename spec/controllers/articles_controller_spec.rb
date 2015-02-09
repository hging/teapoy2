# coding: utf-8
require 'spec_helper'

describe ArticlesController, :type => :controller do
  let(:author){create :user}
  let(:group){create :group, :alias => 'pool'}

  describe '#index' do
    context "there is a published article: " do
      let(:article){create :article, group: group, user: author, slug: 'test', status: 'publish'}
      it "should show speicific article" do
        get :show, :group_id => group.alias, :id => article.slug
        expect(response).to be_success
        expect(assigns(:article)).to eq(article)
      end
    end

    context "there is a private article:" do
      let(:article) { create :article, group: group, user: author, cached_slug: 'test', status: 'private' }
      context "the viewing user is author" do
        before :each do
          @current_user = article.user
          session[:user_id] = @current_user.id
        end
        it "should show this article" do
          get :show, {group_id: group.alias, id: article.cached_slug}
          expect(response).to be_success
        end
      end
      it "should not show this article" do

      end
    end
  end

  describe '#create' do

  end
end
