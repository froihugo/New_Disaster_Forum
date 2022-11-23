class OrderSlackNotifyJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find order_id
    notifier = Slack::Notifier.new 'https://hooks.slack.com/services/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'
    notifier.ping "You top-up #{order.amount} successfully\norder_number is #{order.serial_number}"
  end
end