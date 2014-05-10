require_relative 'command'

module Kansei
  # Implements a command loop for debugging.
  class REPL
    def initialize(game)
      @command = Command.new(game)
    end

    def start
      loop do
        out = parse(gets.rstrip.split(' '))
        break if out.nil?
        puts out
      end
    end

    def cmd(*cmd)
      puts parse(cmd)
    end

    def parse(args)
      cmd = args.shift || :help

      return @command.send(cmd, *args) if
        @command.public_methods(false).include? cmd.to_sym

      %[I wasn't programmed to "#{cmd}" :^)]
    rescue ArgumentError => e
      "#{cmd}: #{e.message}"
    end

    protected :parse
  end
end
