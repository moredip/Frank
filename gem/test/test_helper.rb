require 'ostruct'
require 'stringio'
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/spec'
include MiniTest

require 'rr'
class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
end

require_relative '../lib/frank-cucumber/color_helper'
require_relative '../lib/frank-cucumber/frank_helper'
require_relative '../lib/frank-cucumber/launcher'

