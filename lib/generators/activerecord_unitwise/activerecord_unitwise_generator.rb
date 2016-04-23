require 'rails/generators/active_record'

class ActiverecordUnitwiseGenerator < ActiveRecord::Generators::Base
  desc "Create a migration to add unitwise-specific fields to your model. " +
       "The NAME argument is the name of your model, and the following " +
       "arguments are the name of the unitwise attributes."

  argument :attribute_names, :required => true, :type => :array, :desc => "The names of the unitwise attribute(s) to add.",
           :banner => "attr_one attr_two attr_three ..."

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def generate_migration
    migration_template "unitwise_migration.rb.erb", "db/migrate/#{migration_file_name}"
  end

  def migration_name
    "add_unitwise_#{attribute_names.join("_")}_to_#{name.underscore.pluralize}"
  end

  def migration_file_name
    "#{migration_name}.rb"
  end

  def migration_class_name
    migration_name.camelize
  end
end
