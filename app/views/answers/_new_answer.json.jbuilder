json.answer @answer
json.author_email @answer.user.email
json.datetime @answer.created_at.localtime.strftime("%d/%m/%Y, %H:%M")
json.current_user_is_author_of_object current_user.author_of?(@answer.question)

json.attaches @answer.attaches do |attach|
  json.attach attach
  json.attach_name attach['file']
end
