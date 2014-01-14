json.array!(@blanks) do |blank|
  json.extract! blank, :type, :number, :details
  json.url blank_url(blank, format: :json)
end
