ThinkingSphinx::Index.define :comment, with: :active_record do
    #fields
    indexes body, sortable: true
    indexes user.email, as: :author
  
    #attributes
    has user_id, created_at, updated_at
  end
  