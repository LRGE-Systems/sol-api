#
# Métodos e constantes de busca para Itens
#

module Item::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(items.title)) LIKE (LOWER(:search)) OR
    (LOWER(items.description)) LIKE (LOWER(:search))
  }
end
