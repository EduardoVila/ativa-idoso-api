# frozen_string_literal: true

class RequestLogger
  def self.log(req)
    formatted_req = req.to_h

    RequestLog.create!(
      {
        method: formatted_req[:http_method],
        path: formatted_req[:path],
        params: formatted_req[:params],
        headers: formatted_req[:headers],
        body: formatted_req[:body].to_s,
        options: formatted_req[:options]
      }
    )
  end
end
