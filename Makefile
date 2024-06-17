
test1-curl:
	./curl_test_api_key.sh

test2-nanobot:
	nb gemini-api-cartridge.yml - eval "Hello"
