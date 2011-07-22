require 'test_helper'
require 'lib/generators/couchrest_model/testing_helper'

class CouchrestModel::Generators::ModelGeneratorTest < Rails::Generators::TestCase
  destination File.join(Rails.root)
  tests CouchrestModel::Generators::ModelGenerator

  setup :prepare_destination
  setup :copy_routes

  test "invoke with model name" do
    content = run_generator %w(Account)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /CouchRest::Model::Base/, klass
      end
    end
  end
  
  test "invoke with model name and attributes" do
    content = run_generator %w(Account name:string age:integer)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /property :name, :type => String/, klass
        assert_match /property :age, :type => Integer/, klass        
      end
    end
  end  
  
  test "invoke with model name and --casted option" do
    content = run_generator %w(Account --casted)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /Hash/, klass
      end
    end
  end
     
  test "invoke with model name and --timestamps option" do
    content = run_generator %w(Account --timestamps)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /timestamps!/, klass
      end
    end
  end

  test "invoke with model name and --parent option" do
    content = run_generator %w(Admin --parent User)

    assert_file "app/models/admin.rb" do |account|
      assert_class "Admin", account do |klass| 
        assert_no_match /CouchRest::Model::Base/, klass
        assert_match /<\s+User/, klass
      end
    end
  end      
end
