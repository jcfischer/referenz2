# send either a signup_notification or an activation notifaction to a user
# usage:
# ./script/runner ./jobs/send.rb task user_id
# where:
#     task: signup_notification | activation
#  user_id: Valid user id

task = ARGV[0]
user_id = ARGV[1]

logger = Logger.new( 'log/order.log', 'daily')

begin
  @user = User.find user_id
  if @user
    case task
    when "signup_notification": UserMailer.deliver_signup_notification(@user)
    when "activation": UserMailer.deliver_activation(@user)
    end
  end
end
