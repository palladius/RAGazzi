
require 'nano-bots'

puts("TODO import nanobots and langchainrb and instantiate Gemini")

bot = NanoBot.new(cartridge: 'cartridges/gemini-api.yaml')

puts bot.eval('Hello')

# inspired by https://github.com/patterns-ai-core/ecommerce-ai-assistant-demo/blob/main/main.rb
require "irb"
IRB.start(__FILE__)
