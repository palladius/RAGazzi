#!/usr/bin/env ruby

require 'nano-bots'
require 'faraday'

require_relative 'lib/ragazzo'

EMOJI = '👦'


# #bot = NanoBot.new(cartridge: 'cartridges/gemini-api.yaml')
# bot = NanoBot.new(cartridge: 'cartridges/gemini-api.yaml')

# puts bot.eval('Hello')

# inspired by https://github.com/patterns-ai-core/ecommerce-ai-assistant-demo/blob/main/main.rb
# require "irb"
# IRB.start(__FILE__)


def available_ragazzi
  # list of files under samples/ folder
  Dir.glob("samples/*.yaml").map { |f| File.basename(f, ".yaml") }
end

def show_ragazzi
  puts "Available RAGazzi:"
  available_ragazzi.each { |ragazzo| puts "  #{EMOJI} #{ragazzo}" }
  puts "Run a Ragazzo with: ruby main.rb [ragazzo_name] [prompt]"
end

def run_ragazzo(ragazzo_name, prompt)
  # run the specified ragazzo with the prompt
  # puts "Running Ragazzo: #{ragazzo_name} with prompt: #{prompt}"
  # require "samples/#{ragazzo_name}"
  # Ragazzo.new.run(prompt)
  #puts "- ragazzo_name: #{ragazzo_name}"
  #puts "- prompt: '#{prompt}'"
  filename = "samples/#{ragazzo_name}.yaml"
  unless File.exist?(filename)

    help(reason: "Ragazzo not found: #{ragazzo_name}")
    show_ragazzi
    exit 113
  end
  $ragazzo = RAGazzo.new(filename: , prompt:)
  puts("Ragazzo: #{$ragazzo.to_s}")
  $ragazzo.run_rag()
end

def help reason: nil, exit: true, show_ragazzi: false
  puts "Usage: ruby main.rb command [ragazzo_name] [prompt]"
  puts "Commands:"
  puts "  list:          List available Ragazzi"
  puts "  run <ragazzo>: Run a Ragazzo with the specified prompt"
  puts "  help:          Show this help message"
  puts "Error: #{reason}" if reason
  show_ragazzi if show_ragazzi
  exit(111) if exit
end

def parse_args
  if ARGV.empty?
    help reason: 'No args provided'
  elsif ARGV[0] == 'list'
    show_ragazzi
  elsif ARGV[0] == 'run'
    if ARGV.size < 2
      help(reason: 'I need at least 2 ARGV', exit: false, show_ragazzi: true)
    else
      run_ragazzo(ARGV[1], ARGV[2..-1].join(' '))
    end
  elsif ARGV[0] == 'help'
    help reason: 'Since you asked..'
  else
    help reason: "Invalid command: #{ARGV[0]}"
  end
end

def main
  parse_args
  # exit until one ARGV is provided
  #puts ARGV.size
  #puts ARGV[0]
  if ARGV.size < 2
    help
    exit 111
  end
  # exit until ARGV[0] is a valid command
  # exit until ARGV[1] is a valid prompt
  # call Gemini with the prompt
  # print the response
  # exit

end

# ruby include main if its this file
if __FILE__ == $PROGRAM_NAME
  main
end
