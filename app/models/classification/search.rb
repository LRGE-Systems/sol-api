#
# Métodos e constantes de busca para Classificações
#

module Classification::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(classifications.name)) LIKE (LOWER(:search))
  }
end
