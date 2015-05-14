module Searchable
  extend ActiveSupport::Concern

  VALID_NAME = /\A[a-zA-Z\d ]*\Z/i

  module ClassMethods
    ACTIVE_OPTION = 'active'
    DEACTIVE_OPTION = 'deactive'

    LIKE = ' LIKE ?'
    LIKE_OR = ' LIKE ? OR '
    OR_ACTIVE = ' OR active = ?'

    def search query, search_list
      number_query = search_list.size
      if number_query == 1
        search_query = search_list.join + LIKE
      else
        search_query = search_list.join(LIKE_OR) + LIKE
      end

      arr_query = ["%#{query}%"] * number_query

      if query
        if search_active(query) == 2
          return self.all
        elsif search_active(query) == 1
          search_query += OR_ACTIVE
          arr_query << true
        elsif search_active(query) == 0
          search_query += OR_ACTIVE
          arr_query << false
        end

        where( [search_query, *arr_query] )
      else
        all
      end
    end

    private
      def search_active query
        query = query.downcase
        if ACTIVE_OPTION.include?(query) && DEACTIVE_OPTION.include?(query)
          2
        elsif ACTIVE_OPTION.include?(query)
          1
        elsif DEACTIVE_OPTION.include?(query)
          0
        else
          false
        end
      end

  end
end
