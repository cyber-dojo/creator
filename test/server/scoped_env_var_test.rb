# frozen_string_literal: true

require_relative 'creator_test_base'
require_source 'scoped_env_var_helper'

class ScopedEnvVarTest < CreatorTestBase
  def self.id58_prefix
    :r7h
  end

  include ScopedEnvVarHelper

  # - - - - - - - - - - - - - - - - -

  qtest w9A: %w[
    |Scoped env-var is present inside the scope only
  ] do
    name = 'BERTY_BASSET'
    value = 'sweets42'
    assert_nil ENV[name]
    scoped_env_var(name, value) do
      assert_equal value, ENV[name]
    end
    assert_nil ENV[name]
  end

  # - - - - - - - - - - - - - - - - -

  qtest w9B: %w[
    |Scoped env-var resets to previous value at end of scope
  ] do
    name = 'FRED_BASSET'
    value = 'dog42'
    assert_nil ENV[name]
    scoped_env_var(name, value) do
      assert_equal value, ENV[name]
      scoped_env_var("#{name}X", "#{value}X") do
        assert_equal "#{value}X", ENV["#{name}X"]
      end
      assert_equal value, ENV[name]
    end
    assert_nil ENV[name]
  end
end
