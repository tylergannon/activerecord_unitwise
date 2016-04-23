module ActiverecordUnitwise
  require 'rails'
  require 'unitwise'

  class Railtie < Rails::Railtie
    initializer 'unitwise.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiverecordUnitwise::Railtie.insert
      end
    end

    # rake_tasks { load "tasks/paperclip.rake" }
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.send(:include, ActiverecordUnitwise::Glue)
      end
    end
  end
end
