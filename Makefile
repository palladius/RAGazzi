

test: test1-curl test2-gbaptista test3-nanobot-key

test1-curl:
	./curl_test_api_key.sh

test2-gbaptista:
	ruby test2.rb

# BROKEN: https://github.com/icebaker/ruby-nano-bots/issues/21
test3-nanobot-key:
	nb gemini-api-cartridge.yml - eval "Hello"
