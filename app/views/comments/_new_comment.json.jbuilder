json.new_comment do
  json.self comment
  json.user comment.user
  json.datetime comment.created_at.localtime.strftime("%d/%m/%Y, %H:%M")
end
