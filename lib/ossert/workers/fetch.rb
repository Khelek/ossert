# frozen_string_literal: true
module Ossert
  module Workers
    class Fetch
      include Sidekiq::Worker
      include Process
      sidekiq_options unique: :until_executed,
                      unique_expiration: 1.hour,
                      retry: 3

      def perform(name)
        puts "Fetching data for: '#{name}'"
        pid = fork do
          Ossert.init
          Ossert::Project.fetch_all(name)
        end
        waitpid(pid)
      end
    end
  end
end
