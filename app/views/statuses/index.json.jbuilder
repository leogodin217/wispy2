json.array!(@statuses) do |status|
  json.extract! status, :id, :status, :active
  json.url status_url(status, format: :json)
end
