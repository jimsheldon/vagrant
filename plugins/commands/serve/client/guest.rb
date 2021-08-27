require "google/protobuf/well_known_types"

module VagrantPlugins
  module CommandServe
    module Client
      class Guest
        include CapabilityPlatform

        extend Util::Connector

        attr_reader :broker
        attr_reader :client
        attr_reader :proto

        def initialize(conn, proto, broker=nil)
          @logger = Log4r::Logger.new("vagrant::command::serve::client::guest")
          @logger.debug("connecting to guest service on #{conn}")
          @client = SDK::GuestService::Stub.new(conn, :this_channel_is_insecure)
          @broker = broker
          @proto = proto
        end

        def self.load(raw_guest, broker:)
          g = raw_guest.is_a?(String) ? SDK::Args::Guest.decode(raw_guest) : raw_guest
          self.new(connect(proto: g, broker: broker), g, broker)
        end

        # @return [<String>] parents
        def parents
          @logger.debug("getting parents")
          req = SDK::FuncSpec::Args.new(
            args: []
          )
          res = client.parents(req)
          @logger.debug("got parents #{res}")
          res.parents
        end
      end
    end
  end
end
