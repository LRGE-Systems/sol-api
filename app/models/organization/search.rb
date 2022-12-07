#
# Métodos e constantes de busca para Cidades
#

module Organization::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(organizations.name)) LIKE (LOWER(:search))
  }
end
