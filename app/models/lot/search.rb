#
# Métodos e constantes de busca para Lotes de Licitações
#

module Lot::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(lot.name)) LIKE (LOWER(:search))
  }
end
