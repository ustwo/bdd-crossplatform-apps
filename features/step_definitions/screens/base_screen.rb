class BaseScreen

	attr_accessor :ids

	def initialize ids
		@ids = ids
	end

	def wait_for_load
		# NOTE (JD): get rid of the sleep
		# and monitor the state of the loaders
		sleep 2
	end
end
