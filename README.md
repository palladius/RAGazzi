# RAGazzi

Self: https://github.com/palladius/ragazzi

RAGazzi is the non-plus-ultra distillation of RAG-as-a-Service (ragaas)

# Context

I was inspired by the idea of Nanobots https://github.com/icebaker/ruby-nano-bots and by my previous work on RAG and Wassser temperature ([article](https://medium.com/p/de69215d43df)) and I thought:

* How about creating a RAG-as-a-Service (RAGaaS) script and distill the `RAGs to Ricks` into YAML like the [Nanobots](https://github.com/icebaker/ruby-nano-bots), but focussed on RAG?
* While I'm there, how about finding a nice Italian name for it? how abut `RAGazzi`? Probably it would be better `RAGaaSsuoli` since we do RAG as a Service and grounding can be considered as `suolo` in italian. Plus my friends Fiore&Grufi like to say "ragassi" instead of ragazzi.

But again, if you're not Italian you're not probably getting these jokes, so enough with them.

# Implementation

I think it's cooler to lean on top of `ruby-nano-bots`, or of `langchainrb` to minimize the code.

# Running it

First install `html2text`.

```
 ./main.rb run latest-news-italy
```

## Samples

```
# samples/zurich-lake-water-temperature.yaml
RAG:
  context: |
    You are a weather assistant. You check online for online water temperature and answer questions.
  description: |
    A list of water temperatures for the zurich see.
  urls:
  - https://www.badi-info.ch/_temp/zuerichsee-temperatur.htm
  - https://www.zh.ch/de/umwelt-tiere/wasser-gewaesser/messdaten/wassertemperaturen.html
  - https://www.boot24.ch/chde/service/temperaturen/zuerichsee/
  - https://www.bodenseee.net/wassertemperatur/zuerichsee/
  questions:
  - "What is the temperature of the ZurichSee today? And what about tomorrow forecast?"
  - "I like to swim in Utoquai or Mythenquai. What are the badi temperatures for these two? What's the difference in °C?"
  - "What's the temperature today vs the monthly average for this month?"
  - "Provide a JSON with 3 values: zurichsee_temperature_today, zuri
```

# Thanks

* https://github.com/icebaker/ruby-nano-bots
* https://github.com/patterns-ai-core/langchainrb
