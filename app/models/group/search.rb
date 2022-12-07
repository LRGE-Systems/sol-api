#
# Métodos e constantes de busca para Grupos
#

module Group::Search
  extend ActiveSupport::Concern
  include Searchable

  SEARCH_EXPRESSION = %q{
    (LOWER(groups.name)) LIKE (LOWER(:search))
  }
end
