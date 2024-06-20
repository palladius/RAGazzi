
# sample file
# RAG:
#   context: |
#     You are a weather assistant. You check online for online water temperature and answer questions.
#   description: |
#     A list of water temperatures for the zurich see.
#   urls:
#   - https://www.badi-info.ch/_temp/zuerichsee-temperatur.htm
#   - https://www.zh.ch/de/umwelt-tiere/wasser-gewaesser/messdaten/wassertemperaturen.html
#   - https://www.boot24.ch/chde/service/temperaturen/zuerichsee/
#   - https://www.bodenseee.net/wassertemperatur/zuerichsee/
#   questions:
#   - "What is the temperature of the ZurichSee today? And what about tomorrow forecast?"
#   - "I like to swim in Utoquai or Mythenquai. What are the badi temperatures for these two? What's the difference in °C?"
#   # TODO see if you want to eval this, which is potentially dangerous.
#   #- "What's the temperature today vs the monthly average for this month? Today its <%=Date.today%>"
#   - "What's the temperature today vs the monthly average for this month?"

# Requires # On Debian/Ubuntu systems
# sudo apt-get install html2text
# On macOS (using Homebrew)
# brew install html2text

InitialPrompt = <<PROMPT
You are a helpful assistant trying to answer questions from user based on information retrieved online right now.
I will provide you with URLs and their content, separated by this string: "---------------------------------------".
Finally I'll provide you with a question. Please give me an answer to that questions at the best of your ability leveraging what you read on those URLs which provide additional context.

For your information, the current date is: #{Date.today}.
PROMPT
PromptSeparator = "\n---------------------------------------\n\n"
ChosingPrompt = "\nAnswer: "

class RAGazzo
  # wrapper around the samples YAML files.

  attr_reader :filename, :prompt, :config, :name # , :urls


  def initialize(filename: , prompt: '')
    puts("Ragazzo filename: #{filename}")
    raise "Unknown file: #{filename}" unless File.exist?(filename)
    @config= YAML.load_file(filename)
    @filename = filename
    @prompt = prompt.to_s.empty?  ? any_prompt : prompt
    @name = File.basename(filename, '.yaml')
    # process yanml content
    puts(@config['RAG']['questions'])
  end


  def any_prompt
    puts("Warning. Prompt is not provided. Picking a random one.")
    prompts.sample
  end

  def prompts
    @config['RAG']['questions']
  end
  def urls
    @config['RAG']['urls'].sort
  end

  def to_s(verbose: false)
    "RAGazzo(name=#{ @name }, filename=#{filename}, prompt=#{prompt})"
  end

  def build_rag_file(rag_file:, verbose: true)
    puts("build_rag_file: #{rag_file}")
    # foces write to utf8 - https://stackoverflow.com/questions/5163339/write-and-read-a-file-with-utf-8-encoding
    File.open(rag_file, "w:UTF-8") do |f|
      f.write(InitialPrompt)

      urls.each do |url|
        puts("* Fetching URL: #{url}")
        buridone = text_curl(url) rescue nil
        if buridone
          f.write(PromptSeparator)
          f.write("From URL: #{url}\n\n")
          puts(buridone) if verbose
          #f.write(buridone.force_encoding("utf-8"))
          #f.write(buridone.encode("iso-8859-1").force_encoding("utf-8"))
          f.write(buridone)
          #f.write(buridone.force_encoding("utf-8"))
          #f.write buridone.force_encoding(Encoding::UTF_8)
        else
          puts("Some error fetching URL: #{url} => skipping")
        end
        #puts(buridone) if verbose
      end
      f.write(PromptSeparator)
      f.write("Question: #{prompt}\n\n")
      f.write(ChosingPrompt)
      #puts(prompt) if verbose)
    end
  end

  def text_curl(url)
    `curl -s '#{url}' | html2text`
  end


  def run_rag()
    puts "run_rag - wait for it"
    puts("+ RAGazzo: #{name}")
    puts("+ Prompts: #{prompts}")
    puts("+ URLs to fetch: #{urls.count}")
    #puts("+ Questions: #{questions.count}")
    rag_file = "out/tmp.#{ @name }.prompt"
    ret = build_rag_file(rag_file:)
    # execute rag
    puts("+ Now executing RAG on this prompt: '#{prompt}'..")
    execute_rag(rag_file:)
  end

  def execute_nanobot(rag_file:, cartridge:, name:)
      puts("+ execute_nanobot(cartridge: #{cartridge}, name: #{name}):..")

      ret  = `cat '#{rag_file}' | nb cartridges/gemini-svcacct.yaml - eval >'#{rag_file}.#{name}.out' 2>'#{rag_file}.#{name}.err'` # rescue nil
      if $?.exitstatus != 0
        puts("❎ 'Gemini #{name}' Error ($?=#{$?.exitstatus}). For more type:   cat #{rag_file}.#{name}.err")
        puts `head -1 #{rag_file}.#{name}.err`
      end
      # cleanup
      if File.empty?("#{rag_file}.#{name}.out")
        puts 'cleaning up'
        FileUtils.rm("#{rag_file}.#{name}.out")
      end
  end

  # super lazy..
  def execute_rag(rag_file:, engine: :ollama, ollama_model: :gemma)
    # 1. ollama - WORKS
    if engine == :ollama || engine == :all
      puts("+ execute_rag(): 🦙🦙 OLLAMA models..")
      # TODO discrimintate between Gemma and Llama3.. for now we do both
      puts("+ execute_rag(): Gemma..")
      `cat '#{rag_file}' | ollama run gemma | tee '#{rag_file}.ollama_gemma.out'`
      puts("+ execute_rag(): Llama3..")
      `cat '#{rag_file}' | ollama run llama3 | tee '#{rag_file}.ollama_llama3.out'`
    end

    if engine == :gemini
      # 2. nanobot - CLI
      puts("+ execute_rag(): Gemini via CLI..")
      puts("  - Prerequisite[SA]: env[GOOGLE_REGION]='#{ENV['GOOGLE_CREDENTIALS_FILE_PATH']}'")
      puts("  - Prerequisite[SA]: env[GOOGLE_REGION]='#{ENV['GOOGLE_REGION']}'")
      puts("  - Prerequisite[AK]: env[GOOGLE_API_KEY]='#{ENV['GOOGLE_API_KEY']}'")
      puts('This is useless, IMHO its not reading the input or doesnt have enough tokens.')
      # puts("+ execute_rag(): Gemini SA..")
      # ret  = `cat '#{rag_file}' | nb cartridges/gemini-svcacct.yaml - eval >'#{rag_file}.gemini-pro-sa.out' 2>'#{rag_file}.gemini-pro-sa.err'` # rescue nil
      # if $?.exitstatus != 0
      #   puts("❎ 'Gemini SA' Error ($?=#{$?.exitstatus}): cat #{rag_file}.gemini-pro-sa.err")
      #   puts `head -1 #{rag_file}.gemini-pro-sa.err`
      # end
      execute_nanobot(rag_file:, cartridge: 'cartridges/gemini-svcacct.yaml', name: :gemini_svc_acct) # should work
      execute_nanobot(rag_file:, cartridge: 'cartridges/gemini-api.yaml', name: :gemini_api_key) # should be broken
      # puts("+ execute_rag(): Gemini AK..")
      # ret = `cat '#{rag_file}' | nb cartridges/gemini-api.yaml     - eval >'#{rag_file}.gemini-pro-api.out' 2>'#{rag_file}.gemini-pro-api.err'` # rescue nil
      # if $?.exitstatus != 0
      #   puts("❎ 'Gemini API KEY' Error ($?=#{$?.exitstatus}): #{$!}")
      # end
    end

    # 2. nanobot - Ruby  - more idiomatic but i need to run!
    # todo
  end

end
