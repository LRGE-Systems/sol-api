#
# Métodos e constantes de busca para Cargos
#

module Role::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(roles.title)) LIKE (LOWER(:search))
  }
end
