RSpec.shared_examples 'deliver_later' do |params|
  it params do
    load_params
    message_delivery = instance_double(ActionMailer::MessageDelivery)
    expect(@class).to receive(@method.to_s).and_return(message_delivery)
    expect(message_delivery).to receive(:deliver_later)
    action
  end
end
