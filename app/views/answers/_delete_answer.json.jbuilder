json.destroy do
  json.answer answer
  if answer.errors.any?
    json.partial! 'common/errors', resource: answer
  end
end
