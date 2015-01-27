class BaseScreen

	def ids
		raise "SubclassResponsibility - your AndroidScreen/IosScreen should override this method!" 
	end

	def is_on_screen id
		$driver.find_element(id: id).displayed?
	end

	def wait_for_load
		# NOTE (JD): get rid of the sleep
		# and monitor the state of the loaders
		sleep 2
	end
end
