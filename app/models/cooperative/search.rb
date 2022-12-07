#
# Métodos e constantes de busca para Associações
#

module Cooperative::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(cooperatives.name)) LIKE (LOWER(:search)) OR
    (LOWER(cooperatives.cnpj)) LIKE (LOWER(:search))
  }
end
