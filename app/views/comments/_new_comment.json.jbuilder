json.new_comment do
  json.comment comment
  json.user comment.user
  json.datetime comment.created_at.localtime.strftime("%d/%m/%Y, %H:%M")
end
