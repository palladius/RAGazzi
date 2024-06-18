#!/usr/bin/env ruby

require 'nano-bots'
require 'faraday'
require 'pp'
require 'pry'

module Faraday
  # Response represents an HTTP response from making an HTTP request.
  class Response
    extend Forwardable
    extend MiddlewareRegistry

    def on_complete(&block)
      verbose = false
      puts("🙈 Riccardo nice monkeypatch. to_hash=#{to_hash}")
      puts("🙈 Riccardo nice monkeypatch. 1. Request=#{env.request_body}")
      puts("🙈 Riccardo nice monkeypatch. 2. Response Headers=#{env.response_headers}")
      puts("🙈 Riccardo nice monkeypatch. 2. Response Body=#{env.response_body}")
      puts("🙈 Riccardo nice monkeypatch. env.keys=#{env.keys}")
      puts("🙈 Riccardo nice monkeypatch. env=#{env}") if verbose
      nice_env = Pry::ColorPrinter.pp(env)
      File.write('t.faraday.txt', nice_env, mode: 'w')
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
end

puts '👋 Testing Faraday after monkeypatching it..'
bot = NanoBot.new(cartridge: 'cartridges/gemini-api.yaml')

puts bot.eval('Write a story about a magic backpack')
