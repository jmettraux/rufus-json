#--
# Copyright (c) 2009-2010, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


module Rufus
module Json

  VERSION = '1.0.0'

  # The JSON / JSON pure decoder
  #
  JSON = [
    lambda { |o, opts|
      opts[:max_nesting] = false unless opts.has_key?(:max_nesting)
      if o.is_a?(Hash) or o.is_a?(Array)
        ::JSON.generate(o, opts)
      else
        ::JSON.generate([ o ], opts).strip[1..-2]
      end
    },
    lambda { |s| ::JSON.parse("[#{s}]", :max_nesting => nil).first },
    lambda { ::JSON::ParserError }
  ]

  # The Rails ActiveSupport::JSON decoder
  #
  ACTIVE_SUPPORT = [
    lambda { |o, opts| ActiveSupport::JSON.encode(o, opts) },
    lambda { |s| decode_e(s) || ActiveSupport::JSON.decode(s) },
    #lambda { ::ActiveSupport::JSON::ParseError }
    lambda { RuntimeError }
  ]
  ACTIVE = ACTIVE_SUPPORT

  # http://github.com/brianmario/yajl-ruby/
  #
  YAJL = [
    lambda { |o, opts| Yajl::Encoder.encode(o, opts) },
    lambda { |s| Yajl::Parser.parse(s) },
    lambda { ::Yajl::ParseError }
  ]

  # The "raise an exception because there's no backend" backend
  #
  NONE = [
    lambda { |o, opts| raise 'no JSON backend found' },
    lambda { |s| raise 'no JSON backend found' },
    lambda { raise 'no JSON backend found' }
  ]

  # [Re-]Attempts to detect a JSON backend
  #
  def self.detect_backend

    @backend = if defined?(::Yajl)
      YAJL
    elsif defined?(::JSON)
      JSON
    elsif defined?(ActiveSupport::JSON)
      ACTIVE_SUPPORT
    else
      NONE
    end
  end

  detect_backend
    # run it right now

  # Returns true if there is a backend set for parsing/encoding JSON
  #
  def self.has_backend?

    (@backend != NONE)
  end

  # Returns :yajl|:json|:active|:none (an identifier for the current backend)
  #
  def self.backend

    %w[ yajl json active none ].find { |b|
      Rufus::Json.const_get(b.upcase) == @backend
    }.to_sym
  end

  # Forces a decoder JSON/ACTIVE_SUPPORT or any lambda pair that knows
  # how to deal with JSON.
  #
  # It's OK to pass a symbol as well, :yajl, :json, :active (or :none).
  #
  def self.backend=(b)

    if b.is_a?(Symbol)
      b = { :yajl => YAJL, :json => JSON, :active => ACTIVE, :none => NONE }[b]
    end

    @backend = b
  end

  # Encodes the given object to a JSON string.
  #
  def self.encode(o, opts={})

    @backend[0].call(o, opts)
  end

  # Pretty encoding
  #
  def self.pretty_encode(o)

    case @backend
      when JSON
        encode(o, :indent => '  ', :object_nl => "\n", :array_nl => "\n", :space => ' ')
      when YAJL
        encode(o, :pretty => true, :indent => '  ')
      else
        encode(o)
    end
  end

  # An alias for .encode
  #
  def self.dump(o, opts={})

    encode(o, opts)
  end

  # Decodes the given JSON string.
  #
  def self.decode(s)

    @backend[1].call(s)

  rescue @backend[2].call => e
    raise ParserError.new(e.message)
  end

  # An alias for .decode
  #
  def self.load(s)

    decode(s)
  end

  # Duplicates an object by turning it into JSON and back.
  #
  # Don't laugh, yajl-ruby makes that faster than a Marshal copy.
  #
  def self.dup(o)

    (@backend == NONE) ? Marshal.load(Marshal.dump(o)) : decode(encode(o))
  end

  E_REGEX = /^\d+(\.\d+)?[eE][+-]?\d+$/

  # Let's ActiveSupport do the E number notation.
  #
  def self.decode_e(s)

    s.match(E_REGEX) ? eval(s) : false
  end

  # Wraps parser errors during decode
  #
  class ParserError < StandardError; end
end
end

