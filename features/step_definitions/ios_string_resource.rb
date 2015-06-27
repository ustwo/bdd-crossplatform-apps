#
# The MIT License (MIT)
#
# Copyright (c) 2015 ustwo™
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require_relative 'string_resource'

class IosStringResource < StringResource

 def initialize(file_content:)
   @lines = file_content.split(/\r?\n/)
 end

 def get(key:)
   localised = nil
   @lines.each do |line|

     # line matches the pattern:
     # "KEY" = "VALUE";
     line.match(/^"{1}(.*)"{1}\s+=\s+"{1}(.*)"{1};{1}$/) { |match|
       if match[1] == key
         localised = match[2]
       end
     }

     break if localised != nil
   end

   if localised.nil?
     not_found
   else
     localised
   end
 end
end
