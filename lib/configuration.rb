class Configuration 
    include Singleton
    attr_reader :vars

    def initialize
        load_configuration
    end

    def reload
        load_configuration
    end

    def [](key)
        @vars[key]
    end

    private
    def load_configuration
        dir = File.join(File.dirname(__FILE__), "../config")

        if (ENV['RACK_ENV']) == "development"
            ap "Loading development configuration"
            @vars = TOML.load_file(File.join(dir, "badsanta_dev.conf"))
        end
        if (ENV['RACK_ENV']) == "production"
            ap "Loading production configuration"
            @vars = TOML.load_file(File.join(dir, "badsanta_prod.conf"))
        end
    end
end
