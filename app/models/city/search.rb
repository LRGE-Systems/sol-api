#
# Métodos e constantes de busca para Cidades
#

module City::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(cities.name)) LIKE (LOWER(:search))
  }
end
