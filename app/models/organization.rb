class Organization < ApplicationRecord
    include Organization::Search
    include ::I18nable
    validates_presence_of :name, :locale, :country, :projectId
    

    def self.default_sort_column
        'organizations.name'
    end

    def text
        "#{name}"
    end
end
