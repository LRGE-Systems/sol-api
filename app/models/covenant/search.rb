#
# Métodos e constantes de busca para Convênios
#

module Covenant::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(covenants.number)) LIKE (LOWER(:search)) OR
    (LOWER(covenants.name)) LIKE (LOWER(:search))
  }
end
