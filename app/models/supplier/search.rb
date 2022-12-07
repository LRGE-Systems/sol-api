#
# Métodos e constantes de busca para Usuários de Fornecedor
#

module Supplier::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(suppliers.name)) LIKE (LOWER(:search)) OR
    (LOWER(suppliers.cpf)) LIKE (LOWER(:search)) OR
    (LOWER(suppliers.phone)) LIKE (LOWER(:search)) OR
    (LOWER(suppliers.email)) LIKE (LOWER(:search))
  }
end
