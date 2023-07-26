#
# Métodos e constantes de busca para Cidades
#

module Country::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(countries.name)) LIKE (LOWER(:search))
  }
end
