module HttpJsonHash
  class ServiceError < RuntimeError
    def initialize(path, args, name, body, status, message)
      @path = path
      @args = args
      @name = name
      @body = body
      @status = status
      super(message)
    end

    attr_reader :path, :args, :name, :body, :status
  end
end
