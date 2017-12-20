json.publish do
  json.answer answer
  json.author answer.user
  json.datetime answer.created_at.localtime.strftime("%d/%m/%Y, %H:%M")

  json.attaches answer.attaches do |attach|
    json.attach attach
    json.attach_name attach['file']
  end
end
