#
# Métodos e constantes de busca para Contratos
#

module Contract::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(contracts.title)) LIKE (LOWER(:search))
  }
end
