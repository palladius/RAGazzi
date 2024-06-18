#!/usr/bin/env ruby
=begin
  I still get a 400. Seems like 400 means API key not valid.
  https://stackoverflow.com/questions/77681343/googlegenerativeaierror-400-bad-request-api-key-not-valid-please-pass-a-vali
  But my key is valid since I use it as it is in the curl_test_api_key.sh and it works!!!

=end

require 'nano-bots'
require 'faraday'
require 'pp'
require 'pry'

# WOW: Healthy monjkeypatching through prepend.

module Faraday
  # Response represents an HTTP response from making an HTTP request.
  # UGLY monkeypatching
  class Response
    #extend Forwardable
    #extend MiddlewareRegistry

    def on_complete(&block)
      verbose = false
      puts("🙉 Riccardo monkeypatch Faraday::Response on_complete()")

      puts("  🙈 on_complete() to_hash=#{to_hash}")
      puts("  🙈 on_complete() url=#{env.url}")
      puts("  🙈 on_complete() => Request Body=#{env.request_body}")
      puts("  🙈 on_complete() => Request Headers=#{env.request_headers}")
      puts("  🙈 on_complete() <= Response Headers=#{env.response_headers}")
      puts("  🙈 on_complete() <= Response Body=#{env.response_body}")
      puts("  🙈 on_complete() env.keys=#{env.keys}")
      puts("  🙈 on_complete() env=#{env}") if verbose
      #nice_env = Pry::ColorPrinter.pp(env)
      #File.write('t.faraday.txt', nice_env, mode: 'w')
      File.open('t.faraday.txt', mode: 'w') do |f|
        PP.pp(env, f)
      end
      File.open('t.faraday_color.txt', mode: 'w') do |f|
        Pry::ColorPrinter.pp(env, f)
      end

 #     File.write('/path/to/file', 'Some glorious content', mode: 'a')

      if finished?
        puts('👋 finished OK')
        yield(env)
      else
        @on_complete_callbacks << block
      end
      self
    end
  end
  # from connection.rb


    # PRETTY monkeypatching through super and prepend.
  module FaradayConnectionExtensions
    def run_request(method, url, body, headers)
      puts("🙉 Riccardo monkeypatch Faraday::Connection run_request")
      puts("  🙉 run_request() method=#{method}")
      puts("  🙉 run_request() url=#{url}")
      puts("  🙉 run_request() body=#{body}")
      puts("  🙉 run_request() headers=#{headers}")
      puts("🙉 run_request() Hmmm seems a lot of empty stuff, I need to dig deeper")
      super(method, url, body, headers)
    end
  end


  class Connection
    prepend FaradayConnectionExtensions
    # https://stackoverflow.com/questions/4470108/when-monkey-patching-an-instance-method-can-you-call-the-overridden-method-from

    # def run_request(method, url, body, headers)
    # end
  end
end

puts '👋 Testing Faraday after monkeypatching it..'
bot = NanoBot.new(cartridge: 'cartridges/gemini-api.yaml')

puts bot.eval('Write a story about a magic backpack')
