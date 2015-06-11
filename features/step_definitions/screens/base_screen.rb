class BaseScreen
	ANDROID_PACKAGE_ELEMENT_ID_PREFIX = 'com.ustwo.sample.local:id/'

	def initialize platform, driver
		@platform = platform
		@driver = driver

		# Load the platform specific String resource handler.
		case @platform
		when 'android'
			# TODO: Load in the correct locale Strings for the current test run
			content = File.read('android/app/src/main/res/values/strings.xml')
			@string_resource = AndroidStringResource.new(file_content: content)
		when 'ios'
			# TODO: Create IOSStringResource handler
		end
 	end

	def wait_for_load
		# NOTE (JD): get rid of the sleep
		# and monitor the state of the loaders
		sleep 2
	end

	def id
		raise 'SubclassResponsibility - your AndroidScreen/IosScreen should override this method!'
	end

	def ids
		raise 'SubclassResponsibility - your AndroidScreen/IosScreen should override this method!'
	end

	private
	def get_id id
		element_id = ''
		case @platform
		when 'android'
			# We need the package name at the start of the id for android unless what we're 
			# testing has already been fully qualified, e.g. if it's part of the system UI
			element = ids[id]
			element_id = element[:id] 
			if !element[:is_fully_qualified]
				element_id = ANDROID_PACKAGE_ELEMENT_ID_PREFIX + element[:id] 
			end
		when 'ios'
			element_id = ids[id]
		end

		element_id
	end

	def element id
		@driver.find_element(id: id)
	end

	def elements id
		@driver.find_elements(id: id)
	end

	def element_by_text text
		@driver.find_element(name: text)
	end

	def elements_by_text text
		@driver.find_elements(name: text)
	end

	def has_element id
		begin
			e = element(id)
			!e.nil? && e.displayed?
		rescue
			false
		end
	end

	def has_no_element id
		@driver.set_wait(0)

		has = nil

		500.times do
			has = has_element(id)
			break if !has
			sleep 0.2
		end

		@driver.set_wait(30)
		!has
	end

	def get_text id
		element(id).text
	end

	def get_string_resource key
		@string_resource.get(key: key)
	end
end
