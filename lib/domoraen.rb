# coding:utf-8

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Domoraen
	SLEEP = 60
	VERSION = File.read(File.join File.dirname(__FILE__), '../VERSION').chomp

	@env = ENV['DOMORAEN_ENV'] || 'test'

	class << self
		attr_accessor :env

		def start
			@domoraen = Domoraen::Bot.new(
				config_file: File.dirname(__FILE__) + "/../conf/#{Domoraen.env}.yaml"
			)
			@domoraen.markov.load_chains('hatsumei')
			@domoraen.update_profile
			@domoraen.log 'starting'

			loop do
				@domoraen.log 'loop start'
				begin
					if rand(10) == 1
						@domoraen.log 'tweeting'
						if text = @domoraen.produce_tool
							@domoraen.tweet(text)
						end
					end

					if rand(2) == 1
						@domoraen.replies.each do |tweet|
							text = @domoraen.react_to(tweet)
							@domoraen.reply("#{@domoraen.tweet_user(tweet)} #{text}", tweet)
						end
					end

					@domoraen.update_config
				rescue Exception => e
					@domoraen.log e
					@domoraen.tweet "@tily #{e.class}: #{e.message}"
					next
				end

				@domoraen.log 'loop end'
				sleep 60
			end
		end
	end
end

require 'chatterbot'
require 'domoraen/producer'
require 'domoraen/messenger'
require 'domoraen/markov'
require 'domoraen/bot'
require 'domoraen/cli'
