module Searchable
  extend ActiveSupport::Concern

  VALID_NAME = /\A[a-zA-Z\d ]*\Z/i

  module ClassMethods

    def search query, search_list
      number_query = search_list.size
      search_query = search_list.join(' LIKE ? OR ') + ' LIKE ?'

      arr_query = ["%#{query}%"] * number_query

      if query
        where( [search_query, *arr_query] )
      else
        all
      end
    end

  end
end
