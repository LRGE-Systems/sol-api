class Country < ApplicationRecord
    include Country::Search
    include ::Sortable

    has_many :states

    def self.default_sort_column
        'countries.name'
    end
    
    def text
        "#{name}"
    end
end
