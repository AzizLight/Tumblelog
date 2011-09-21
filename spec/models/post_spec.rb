# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  draft      :integer
#  post_type  :string(255)
#  image      :string(255)
#  quote      :string(255)
#

require 'spec_helper'

describe Post do
  before(:each) do
    Factory(:user)
    @attr = {
      :title => "This is the title",
      :body  => "This is the body",
      :user_id => 1,
      :draft => 0,
      :post_type => "text",
      :quote => "Aziz, Light!",
      :link => "http://www.example.com/"
    }
  end

  describe "Validations" do
    describe "title" do
      it "should only require a title if the post type is text" do
        post = Post.new(@attr.merge(:title => nil, :post_type => "text"))
        post.should_not be_valid
      end

      #it "should not require a title if the type is not text" do
        #post = Post.new(@attr.merge(:title => nil, :post_type => "image"))
        #post.should be_valid
      #end

      it "should reject titles that are too long" do
        post = Post.new(@attr.merge(:title => "X" * 256))
        post.should_not be_valid
      end
    end

    describe "body" do
      it "should only require a body if the post type is text" do
        post = Post.new(@attr.merge(:body => nil, :post_type => "text"))
        post.should_not be_valid
      end

      #it "should not require a body if the post type is not text" do
        #post = Post.new(@attr.merge(:body => nil, :post_type => "image"))
        #post.should be_valid
      #end
    end

    describe "user_id" do
      it "should require a user_id" do
        post = Post.new(@attr.merge(:user_id => nil))
        post.should_not be_valid
      end

      it "should require a valid user_id" do
        post = Post.new(@attr.merge(:user_id => "forty two"))
        post.should_not be_valid
        post = Post.new(@attr.merge(:user_id => 0))
        post.should_not be_valid
        post = Post.new(@attr.merge(:user_id => -1))
        post.should_not be_valid
      end
    end

    describe "draft" do
      it "should require a draft attribute" do
        post = Post.new(@attr.merge(:draft => nil))
        post.should_not be_valid
      end
    end

    describe "post_type" do
      it "should require a post type" do
        post = Post.new(@attr.merge(:post_type => nil))
        post.should_not be_valid
      end

      # FIXME: Split that test
      it "should accept valid post types" do
        valid_post_types = %w[text quote link audio video]
        valid_post_types.each do |valid_post_type|
          post = Post.new(@attr.merge(:post_type => valid_post_type))
          post.should be_valid
        end
      end

      it "should reject invalid post types" do
        post = Post.new(@attr.merge(:post_type => "invalid"))
        post.should_not be_valid
      end
    end

    describe "quote" do
      it "should require a quote for posts of type quote" do
        post = Post.new(@attr.merge(:quote => "", :post_type => "quote"))
        post.should_not be_valid

        post = Post.new(@attr.merge(:quote => "", :post_type => "text"))
        post.should be_valid
      end

      it "should reject quotes that are too long" do
        long_quote = "X" * 256
        post = Post.new(@attr.merge(:quote => long_quote, :post_type => "quote"))
        post.should_not be_valid
      end
    end

    describe "link" do
      it "should require a link for posts of type link" do
        post = Post.new(@attr.merge(:link => "", :post_type => "link"))
        post.should_not be_valid
      end

      it "should not require a link for posts of type other than link" do
        post = Post.new(@attr.merge(:link => "", :post_type => "text"))
        post.should be_valid
      end
    end
  end
end
