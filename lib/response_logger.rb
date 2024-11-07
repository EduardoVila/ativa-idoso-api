# frozen_string_literal: true

class ResponseLogger
  def self.log(resp, table_name, pointer = nil)
    if resp.is_a? Faraday::Response
      response_env = resp.env
      formatted_resp = response_env.to_hash
    else
      formatted_resp = resp
    end

    ResponseLog.create!(
      {
        table: table_name,
        table_pointer: pointer,
        method: formatted_resp[:method],
        path: formatted_resp[:url].to_s,
        body: formatted_resp[:body].to_s,
        headers: formatted_resp[:headers],
        status: formatted_resp[:status],
        raw_data: formatted_resp.to_s
      }
    )
  end
end
