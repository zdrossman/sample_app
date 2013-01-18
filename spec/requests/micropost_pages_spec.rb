require 'spec_helper'

describe "MicropostPages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { valid_signin user }

  describe "micropost creation" do
  	before { visit root_path }

  	describe "with invalid information" do

  		it "should not create a micropost" do
  			expect { click_button "Post" }.not_to change(Micropost, :count)
  		end

  		describe "error messages" do
  			before { click_button "Post" }
  			it { should have_content('error') }
  		end
  	end

  	describe "with valid information" do
  		before { fill_in 'micropost_content', with: "Lorem ipsum" }
  		it "should create a micropost" do
  			expect { click_button "Post" }.to change(Micropost, :count).by(1)
  		end
    end
  end

  describe "micropost destruction" do
    before do
      FactoryGirl.create(:micropost, user: user)
      valid_signin(user)
    end

    describe "as user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as other user" do
      before do
        FactoryGirl.create(:micropost, user: other_user)
        valid_signin(other_user)
        visit user_path(user)
      end

      it "should not delete a micropost" do
        should_not include { click_link "delete"}.not_to change(Micropost, :count)
      end
    end
  end

  describe "pagination" do
    before do
      31.times { FactoryGirl.create(:micropost, user: user) }
      valid_signin(user)
      visit root_path
    end
    
    after { user.microposts.delete_all }

    it "should render the user's feed" do
        user.feed[1..28].each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
    end
    
    describe "should have the micropost count and pluralize" do
      it { should have_content("31 microposts") }
    end

    describe "should paginate after 31 posts" do
      it { should have_selector('div.pagination') }
    end
  end
end