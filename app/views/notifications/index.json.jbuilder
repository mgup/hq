json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :content, :visible
  json.url notification_url(notification, format: :json)
end
