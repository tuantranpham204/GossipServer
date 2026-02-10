module ApiStandardization
  extend ActiveSupport::Concern
  def succeed(data: {}, message: "Success.", status: :ok)
    render json: {
      code: Rack::Utils.status_code(status),
      status: status,
      data: data,
      message: message
    }
  end

  def error(data: {}, message: "Error.", status: :bad_request, errors: nil)
    render json: {
      code: Rack::Utils.status_code(status),
      status: status,
      data: data,
      message: message,
      errors: errors
    }
  end

  def paginate(data: {}, message: "Success.", status: :ok, meta: {
    total_pages: nil,
    total_count: nil,
    current_page: nil,
    per_page: nil
  })
    render json: {
      code: Rack::Utils.status_code(status),
      status: status,
      data: data,
      message: message,
      meta: meta
    }
  end
end
