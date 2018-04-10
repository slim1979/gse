class Search < ApplicationRecord
  SEARCH_TYPE = { full_search: ThinkingSphinx, questions: Question, answers: Answer, comments: Comment, users: User }.freeze

<<<<<<< bceba0536c1a51dae23dc7db7b48995da037ce32
  def self.make_search(search_for, search_through)
    search_through = SEARCH_TYPE[search_through.to_sym]
    search_through ||= ThinkingSphinx
    search_through.search ThinkingSphinx::Query.escape(search_for)
=======
  def make_search(search_for, search_through)
    search_through = SEARCH_TYPE[search_through]
    search_through ||= ThinkingSphinx
    search_through.search search_for
>>>>>>> make_search method added
  end
end
