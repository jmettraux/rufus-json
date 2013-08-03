
#
# testing rufus-json
#
# Sat Aug  3 09:37:48 JST 2013
#
# Ishinomaki
#

require 'test/unit'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rufus-json'


class NoBackendTest < Test::Unit::TestCase

  def test_dup

    Rufus::Json.backend = :none

    d0 = { 'id' => 'nada' }
    d1 = { :id => :nada }
    d2 = { :id => { :tree => [ 'nada', {}, [] ] } }

    assert_equal(
      { 'id' => 'nada' }, Rufus::Json.dup(d0))
    assert_equal(
      { 'id' => 'nada' }, Rufus::Json.dup(d1))
    assert_equal(
      { 'id' => { 'tree' => [ 'nada', {}, [] ] } }, Rufus::Json.dup(d2))
  end
end

