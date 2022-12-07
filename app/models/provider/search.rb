#
# Métodos e constantes de busca para Fornecedores
#

module Provider::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(providers.name)) LIKE (LOWER(:search)) OR
    (LOWER(providers.document)) LIKE (LOWER(:search))
  }
end
