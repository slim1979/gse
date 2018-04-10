class Search < ApplicationRecord
  SEARCH_TYPE = { full_search: ThinkingSphinx, questions: Question, answers: Answer, comments: Comment, users: User }.freeze

  def self.make_search(search_for, search_through)
    search_through = SEARCH_TYPE[search_through.to_sym]
    search_through ||= ThinkingSphinx
    search_through.search ThinkingSphinx::Query.escape(search_for)
  end
end
