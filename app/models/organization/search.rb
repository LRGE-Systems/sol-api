#
# Métodos e constantes de busca para Cidades
#

module Organization::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    unaccent(LOWER(organizations.name)) LIKE unaccent(LOWER(:search))
  }
end
