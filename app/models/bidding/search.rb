#
# Métodos e constantes de busca para Licitações
#

module Bidding::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(biddings.title)) LIKE (LOWER(:search)) OR
    (LOWER(biddings.description)) LIKE (LOWER(:search)) OR
    biddings.covenant_id IN (SELECT c.id FROM covenants c WHERE (LOWER(c.number)) LIKE (LOWER(:search)))
  }
end
