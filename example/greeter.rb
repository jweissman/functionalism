require 'functionalism'

include Functionalism
require './example/user'

class Greeting < Struct.new(:message)
  def to_stdout
    puts message
    self
  end
end

class AccessGranted < Greeting
  def self.to(name)
    new("GREETINGS #{name}!")
  end
end

class Unauthorized < Greeting
  def to_stdout
    puts "UNAUTHORIZED"
    self
  end
end

class Greeter
  def greet(username)
    (self.class.greeting_pipeline | :to_stdout).(username)
  end

  protected
  class << self
    def greeting_pipeline
      :authorize_and_format_name.as_method | :build_greeting.as_method
    end

    def authorize_and_format_name(username)
      authz_and_format.(username)
    end

    def build_greeting(strategy: nil, display_name: nil)
      strategy.(display_name)
    end

    def authz_and_format
      ->(*args) do
        {
          strategy: determine_strategy,
          display_name: format_display_name
        }.inject({}) do |hsh,(key,f)|
          hsh[key] = f[*args]; hsh
        end
      end
    end

    def determine_strategy
      :authorized?.as_method_of(User) | :greeting_strategy_by_authorized.as_method
    end

    def format_display_name
      :split.(' ') | :capitalize.each | :reverse | :join.(', ')
    end

    def greeting_strategy_by_authorized(is_authorized)
      if is_authorized
        method(:access_granted)
      else
        method(:access_denied)
      end
    end

    def access_granted(username)
      AccessGranted.to(username)
    end

    def access_denied(*)
      Unauthorized.new
    end
  end
end

if __FILE__ == $0
  Greeter.new.greet("bob dobalina") # => ACCESS GRANTED TO Dobalina, Bob!
  Greeter.new.greet("tom jones")    # => UNAUTHORIZED
end
