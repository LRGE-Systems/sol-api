#
# Métodos e constantes de busca para Usuários de Associação
#

module User::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(users.name)) LIKE (LOWER(:search)) OR
    (LOWER(users.cpf)) LIKE (LOWER(:search)) OR
    (LOWER(users.phone)) LIKE (LOWER(:search)) OR
    (LOWER(users.email)) LIKE (LOWER(:search))
  }
end
