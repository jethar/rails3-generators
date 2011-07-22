require 'generators/couchrest_model'
require 'generators/helpers/model_helper'

module CouchrestModel
  module Generators
    class ModelGenerator < Base

      argument  :attributes,  :type => :array, :default => [],  :banner => "field:type field:type#, posfixing with '#' marks attribute to be indexed"

      class_option :timestamps, :type => :boolean, :aliases => "-T",  :desc => "Add timestamps created_at and updated_at", :default => false
      class_option :casted,  :type => :boolean, :aliases => "-E",  :desc => "Casted document", :default => false
      class_option :parent,  :type => :string,  :aliases => "-P",  :desc => "Class name of parent document"

      # check_class_collision

      attr_accessor :model_attributes, :model_indexes

      def initialize(*args, &block)
        super
        # from helpers/model_helper
        # parse_model_attributes

        @model_attributes = []
        @model_indexes = {}

        @model_attributes = attributes
      end

      def create_model_file
        template 'model.rb', "app/models/#{file_name}.rb"
      end

      protected

        def casted_statement
          "Hash"
        end

        def timestamps_statement
          'timestamps!'
        end

        def statements
          stm_list = []
          stm_list << casted_statement if casted?
          stm_list << timestamps_statement if timestamps?
          stm_list.join("\n")
        end

        def casted?
          options[:casted]
        end

        def parent?
          options[:parent]
        end

        def timestamps?
          options[:timestamps]
        end

        def model_exists?
          File.exist? destination_path("app/models/#{file_name}.rb")
        end

        def model_columns_for_attributes
          class_name.constantize.columns.reject do |column|
            column.name.to_s =~ /^(id|created_at|updated_at)$/
          end
        end
    end
  end
end
