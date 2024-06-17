
test1-curl:
	./curl_test_api_key.sh


# BROKEN: https://github.com/icebaker/ruby-nano-bots/issues/21
test2-nanobot:
	nb gemini-api-cartridge.yml - eval "Hello"
