

test: test1-curl test2-gbaptista test3-nanobot-key

test1-curl:
	./curl_test_api_key.sh

test2-gbaptista:
	ruby test2.rb

# BROKEN: https://github.com/icebaker/ruby-nano-bots/issues/21
test3-nanobot-key: # broken
	nb cartridges/gemini-api.yaml - eval "Hello"
test4-nanobot-key:
	nb cartridges/gemini-svcacct.yaml - eval "Hello"
	nb cartridges/gemini15-svcacct.yaml - eval "Hello"

zurichsee-water:
	cat out/tmp.zurich-lake-water-temperature.prompt | nb assistant.yml - eval > out/tmp.zurich-lake-water-temperature.prompt.gemini-pro.out
italy-news:
	#ruby main.rb run latest-news-italy Summarize any news regarding Italian celebrities

	ruby main.rb run latest-news-italy 'Any news related to Amazon?'

clean:
	rm out/tmp.*
