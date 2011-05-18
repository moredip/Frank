When /^I wait(?: for)? ([\d.]+) second(?:s)?$/ do |seconds|
  seconds = seconds.to_f
  sleep( seconds )
end

