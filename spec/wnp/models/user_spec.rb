require_relative "../../spec_helper"

describe Wnp::Models::User do

  before do
    $data_store = get_memory_datastore()
  end

  def create_user_with_name name
    Wnp::Models::User.create name:name, email:"good@email.com", password:"cool"
  end

  describe "creation" do

    it "should make a user with email" do
      user = create_user_with_name "John"
      assert_equal 1, user.id
      assert_equal "good@email.com", user.email
    end

    it "should make a user without email" do
      user = Wnp::Models::User.create name:"John", password:"cool"
      assert_equal 1, user.id
      assert_equal nil, user.email
    end

    it "should increment the id" do
      u1 = create_user_with_name "John"
      assert_equal 1, u1.id

      u2 = create_user_with_name "Tim"
      assert_equal 2, u2.id
    end

  end

  describe "finding" do

    before do
      create_user_with_name "John"
      create_user_with_name "Tim"
    end

    it "should find first user" do
      assert_equal "John", Wnp::Models::User.find(1).name
    end

    it "should find second user" do
      assert_equal "Tim", Wnp::Models::User.find(2).name
    end

    it "should not find a non-existant user" do
      assert_equal nil, Wnp::Models::User.find(3)
    end

  end

  describe "updating" do

    it "should update a user" do
      create_user_with_name "John"
      user = Wnp::Models::User.find(1)
      assert_equal "John", user.name
      user.name = "Frits"
      user.save

      reloaded_user = Wnp::Models::User.find(1)
      assert_equal reloaded_user.name, "Frits"
    end

    it "should be able to update the password" do
      create_user_with_name "John"
      user = Wnp::Models::User.find(1)
      orig_hashed_password = user.hashed_password

      user.password = "new password"
      user.save

      reloaded_user = Wnp::Models::User.find(1)
      assert reloaded_user.hashed_password != orig_hashed_password

    end

  end

  describe "finding by and indexed attribute" do

    it "should find by an email that exists" do
      Wnp::Models::User.create name:"John", email:"good@email.com", password:"cool"
      user = Wnp::Models::User.find_by_index :email, "good@email.com"
      assert_equal 1, user.id
      assert_equal "John", user.name
    end

  end

  describe "authentication" do

    before do
      Wnp::Models::User.create name:"John", email:"good@email.com", password:"cool"
    end

    it "should authenticate a user by correct name and email" do
      user = Wnp::Models::User.authenticate "good@email.com", "cool"
      assert_equal 1, user.id
      assert_equal "John", user.name
    end

    it "should not authenticate a user if their email is wrong" do
      user = Wnp::Models::User.authenticate "nonexistantemail@hello.com", "cool"
      assert_equal nil, user
    end

    it "should not authenticate a user if their password is wrong" do
      user = Wnp::Models::User.authenticate "good@email.com", "badpassword"
      assert_equal nil, user
    end

  end

  describe "pages" do

    before do
      @user = Wnp::Models::User.create name:"John", email:"good@email.com", password:"cool"
    end

    it "should add, remove, and persist pages" do
      @user.add_page 25
      @user.add_page 32
      @user.add_page 10
      assert_equal [10, 25, 32], @user.page_ids
      @user.remove_page 25
      assert_equal [10, 32], @user.page_ids
      @user.save
      assert_equal [10, 32], Wnp::Models::User.find(1).page_ids
    end

  end

  describe "groups" do

    before do
      @user = Wnp::Models::User.create name:"John", email:"good@email.com", password:"cool"
    end

    it "should add, remove, and persist groups" do
      @user.add_group 25
      @user.add_group 32
      @user.add_group 10
      assert_equal [10, 25, 32], @user.group_ids
      @user.remove_group 25
      assert_equal [10, 32], @user.group_ids
      @user.save
      assert_equal [10, 32], Wnp::Models::User.find(1).group_ids
    end

  end

end