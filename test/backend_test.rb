
#
# testing rufus-json
#
# Fri Jul 31 13:05:37 JST 2009
#

require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rufus/json'
require 'rubygems'


class BackendTest < Test::Unit::TestCase

  def setup
    Rufus::Json.backend = Rufus::Json::NONE
  end
  #def teardown
  #end

  def test_no_backend

    assert_raise RuntimeError do
      Rufus::Json.decode('nada')
    end
  end

  def test_get_backend

    assert_equal :none, Rufus::Json.backend

    require 'json'

    Rufus::Json.detect_backend

    assert_not_equal :none, Rufus::Json.backend
  end

  def test_set_backend

    require 'json'

    Rufus::Json.backend = :json

    assert_equal :json, Rufus::Json.backend
  end
end

