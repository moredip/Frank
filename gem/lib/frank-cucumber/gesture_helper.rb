module Frank
	module Cucumber
		module GestureHelper

			# Touch and hold the selector for a given duration
			#
			# @param [String] selector a view selector.
			# @param [Number] duration the duration of the touch, the default is 1.
			#
			# @return [Array<Boolean>] an array indicating for each view which matched the selector whether it was touched or not.
			#
			# @raise an expection if no views matched the selector
			# @raise an expection if no views which matched the selector could be touched
			def tap_and_hold( selector, duration = 1 )
				touch_successes = frankly_map( selector, "touchAndHold:", duration )
				raise "Could not find anything matching [#{selector}] to long touch" if touch_successes.empty?
			    raise "Some views could not be long touched (probably because they are not within the current viewport)" if touch_successes.include?(false)
			end

			# Touch and hold the selector at a specific point for a given duration
			#
			# @param [String] selector a view selector.
			# @param [Number] duration the duration of the touch, the default is 1.
			# @param [Number] x the x-coordinate to touch
			# @param [Number] y the y-coordinate to touch
			#
			# @return [Array<Boolean>] an array indicating for each view which matched the selector whether it was touched or not.
			#
			# @raise an expection if no views matched the selector
			# @raise an expection if no views which matched the selector could be touched
			def tap_and_hold_point( selector, x, y, duration = 1 )
				touch_successes = frankly_map( selector, "touchAndHold:x:y:", duration, x, y )
				raise "Could not find anything matching [#{selector}] to long touch" if touch_successes.empty?
			    raise "Some views could not be long touched (probably because they are not within the current viewport)" if touch_successes.include?(false)
			end

			# Double tap the selector
			#
			# @param [String] selector a view selector.
			#
			# @return [Array<Boolean>] an array indicating for each view which matched the selector whether it was touched or not.
			#
			# @raise an expection if no views matched the selector
			# @raise an expection if no views which matched the selector could be touched
			def double_tap( selector )
				touch_successes = frankly_map( selector, "doubleTap"  )
				raise "Could not find anything matching [#{selector}] to double tap" if touch_successes.empty?
			    raise "Some views could not be double tap (probably because they are not within the current viewport)" if touch_successes.include?(false)
			end

			# Double tap the selector at a specific point
			#
			# @param [String] selector a view selector.
			# @param [Number] x the x-coordinate to touch
			# @param [Number] y the y-coordinate to touch
			#
			# @return [Array<Boolean>] an array indicating for each view which matched the selector whether it was touched or not.
			#
			# @raise an expection if no views matched the selector
			# @raise an expection if no views which matched the selector could be touched
			def double_tap_point( selector, x, y )
				touch_successes = frankly_map( selector, "doubleTapx:y:", x, y )
				raise "Could not find anything matching [#{selector}] to double tap" if touch_successes.empty?
			    raise "Some views could not be double tap (probably because they are not within the current viewport)" if touch_successes.include?(false)
			end
		end
	end
end
