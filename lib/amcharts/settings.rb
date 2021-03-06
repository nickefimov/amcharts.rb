require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/indifferent_access'

module AmCharts
  class Settings
    delegate :[], :each, :fetch, to: :@settings

    def initialize
      @settings = {}.with_indifferent_access
    end

    def function(name)
      ChartBuilder::Function.new(name)
    end

    def method_missing(name, *args, &block)
      if block_given?
        @settings[name] = block.call(*args)
      elsif name.to_s.end_with?('=') and args.length == 1
        prefix = name.to_s.gsub(/=\z/, '')
        @settings[prefix] = args.first
      elsif !args.empty?
        @settings[name] = args.length == 1 ? args.first : args
      elsif name.to_s.end_with?('?')
        prefix = name.to_s.gsub(/\?\z/, '')
        @settings.key?(prefix)
      else
        @settings[name]
      end
    end
  end
end