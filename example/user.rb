class User
  class << self
    def authorized?(username)
      whitelist.any?(&is_user?(username))
    end

    protected
    def is_user?(username)
      ->(e) { username.match e }
    end

    private
    def whitelist
      %w[ bob mary ]
    end
  end
end

