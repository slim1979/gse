json.answer @answer

json.attaches @answer.attaches do |attach|
  json.attach attach
  json.attach_name attach['file']
end
