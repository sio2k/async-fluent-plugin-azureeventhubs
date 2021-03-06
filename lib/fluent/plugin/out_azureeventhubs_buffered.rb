require "fluent/plugin/output"
require 'fluent/output'
require 'fluent/output_chain'
require 'fluent/plugin/buffer'

module Fluent::Plugin

  class AzureEventHubsOutputBuffered < Fluent::BufferedOutput
    Fluent::Plugin.register_output('azureeventhubs_buffered', self)

    helpers :compat_parameters, :inject

    DEFAULT_BUFFER_TYPE = "memory"

    config_param :connection_string, :string
    config_param :hub_name, :string
    config_param :include_tag, :bool, :default => false
    config_param :include_time, :bool, :default => false
    config_param :tag_time_name, :string, :default => 'time'
    config_param :expiry_interval, :integer, :default => 3600 # 60min
    config_param :type, :string, :default => 'https' # https / amqps (Not Implemented)
    config_param :proxy_addr, :string, :default => ''
    config_param :proxy_port, :integer,:default => 3128
    config_param :open_timeout, :integer,:default => 60
    config_param :read_timeout, :integer,:default => 60
    config_param :max_batch_size, :integer,:default => 100
    config_param :message_properties, :hash, :default => nil


    def initialize
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def prefer_buffered_processing
      true
    end

    def configure(conf)
      compat_parameters_convert(conf, :buffer, :inject)
      super
        require_relative 'azureeventhubs/http'
        @sender = AzureEventHubsHttpSender.new(@connection_string, @hub_name, @expiry_interval,@proxy_addr,@proxy_port,@open_timeout,@read_timeout)
    end

    def format(tag, time, record)
      record = inject_values_to_record(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def formatted_to_msgpack_binary?
      true
    end

    def multi_workers_ready?
      true
    end

    def write(chunk)
      records = []
      chunk.msgpack_each { |tag, time, record|
        records.push(record)
      }
      records.each_slice(@max_batch_size).each { |group|
        @sender.send_w_properties(group, @message_properties)
      }
    end
  end
end