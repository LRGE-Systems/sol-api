#
# Métodos e constantes de busca para Grupos de Itens
#

module GroupItem::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(items.title)) LIKE (LOWER(:search)) OR
    (LOWER(items.description)) LIKE (LOWER(:search))
  }

  SEARCH_INCLUDES = :item
end
