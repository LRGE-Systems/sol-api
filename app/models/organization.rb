class Organization < ApplicationRecord
    include Organization::Search
    validates_presence_of :name

    def self.default_sort_column
        'organizations.name'
    end

    def text
        "#{name}"
    end
end
