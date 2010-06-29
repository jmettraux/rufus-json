
#
# testing rufus-json
#
# Fri Jul 31 13:05:37 JST 2009
#

require 'test/unit'
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rufus/json'
require 'rubygems'


class JsonTest < Test::Unit::TestCase

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

  def test_decode_json

    do_test_decode('json', Rufus::Json::JSON)
  end

  def test_encode_json

    do_test_encode('json', Rufus::Json::JSON)
  end

  def test_dup_json

    do_test_dup('json', Rufus::Json::JSON)
  end

  def test_deep_nesting_json

    do_test_deep_nesting('json', Rufus::Json::JSON)
  end

  def test_parser_error_json

    do_test_parser_error('json', Rufus::Json::JSON)
  end

  def test_json_atoms_json

    do_test_json_atoms('json', Rufus::Json::JSON)
  end

  def test_decode_yajl

    do_test_decode('yajl', Rufus::Json::YAJL)
  end

  def test_encode_yajl

    do_test_encode('yajl', Rufus::Json::YAJL)
  end

  def test_dup_yajl

    do_test_dup('yajl', Rufus::Json::YAJL)
  end

  def test_deep_nesting_yajl

    do_test_deep_nesting('yajl', Rufus::Json::YAJL)
  end

  def test_parser_error_yajl

    do_test_parser_error('yajl', Rufus::Json::YAJL)
  end

  def test_json_atoms_yajl

    do_test_json_atoms('yajl', Rufus::Json::YAJL)
  end

  def test_decode_as

    do_test_decode('active_support', Rufus::Json::ACTIVE)
  end

  def test_encode_as

    do_test_encode('active_support', Rufus::Json::ACTIVE)
  end

  def test_dup_as

    do_test_dup('active_support', Rufus::Json::ACTIVE)
  end

  def test_deep_nesting_as

    do_test_deep_nesting('active_support', Rufus::Json::ACTIVE)
  end

  def test_json_atoms_as

    do_test_json_atoms('active_support', Rufus::Json::ACTIVE)
  end

  protected

  def do_test_decode (lib, cons)

    require lib

    assert_raise RuntimeError do
      Rufus::Json.decode('nada')
    end

    Rufus::Json.backend = cons
    assert_equal [ 1, 2, 3 ], Rufus::Json.decode("[ 1, 2, 3 ]")
  end

  def do_test_encode (lib, cons)

    require lib

    assert_raise RuntimeError do
      Rufus::Json.encode('nada')
    end

    Rufus::Json.backend = cons
    assert_equal "[1,2,3]", Rufus::Json.encode([ 1, 2, 3 ])
  end

  def do_test_dup (lib, cons)

    require lib

    d0 = { 'id' => 'nada' }
    d1 = { :id => :nada }

    Rufus::Json.backend = cons

    assert_equal({ 'id' => 'nada' }, Rufus::Json.dup(d0))
    assert_equal({ 'id' => 'nada' }, Rufus::Json.dup(d1))
  end

  def do_test_deep_nesting (lib, cons)

    require lib
    Rufus::Json.backend = cons

    s = "{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{\"a\":{}}}}}}}}}}}}}}}}}}}}}}"

    h = {}
    p = h
    (1..21).each do |i|
      p['a'] = {}
      p = p['a']
    end

    assert_equal(s, Rufus::Json.encode(h))
    assert_equal(h, Rufus::Json.decode(s))
  end

  def do_test_parser_error (lib, cons)

    require lib
    Rufus::Json.backend = cons

    s = '{foo:cx1234}'

    assert_raise Rufus::Json::ParserError do
      Rufus::Json.decode(s)
    end
  end

  def do_test_json_atoms (lib, cons)

    require lib
    Rufus::Json.backend = cons

    [
      [ '1', 1 ],
      [ '1.1', 1.1 ],
      [ '1.1e10', 1.1e10 ],
      [ '1.1E10', 1.1e10 ],
      [ '1.1E-10', 1.1e-10 ],
      [ '"a"', 'a' ],
      [ 'true', true ],
      [ 'false', false ],
      [ 'null', nil ]
    ].each do |s, v|
      assert_equal v, Rufus::Json.decode(s)
    end
  end
end

