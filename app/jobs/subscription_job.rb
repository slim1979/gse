class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(object)
    object.dome
  end
end
