class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  safelist("allow-localhost") do |req|
    "127.0.0.1" == req.ip || "::1" == req.ip
  end

  # throttle("req/ip", limit: 5, period: 5) do |req|
  #   req.ip
  # end

  self.throttled_response = ->(env) {
    retry_after = (env["rack.attack.match_data"] || {})[:period]
    [
      429,
      {"Content-Type" => "application/json", "Retry-After" => retry_after.to_s},
      [{error: "Throttle limit reached. Retry later."}.to_json]
    ]
  }
end
