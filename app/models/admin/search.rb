#
# Métodos e constantes de busca para Usuários Administradores
#

module Admin::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(admins.name)) LIKE (LOWER(:search)) OR
    (LOWER(admins.email)) LIKE (LOWER(:search))
  }
end
