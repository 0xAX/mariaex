defmodule QueryTest do
  use ExUnit.Case, async: false
  import Mariaex.TestHelper

  setup do
    opts = [ database: "mariaex_test", username: "root" ]
    {:ok, pid} = Mariaex.Connection.start_link(opts)
    {:ok, [pid: pid]}
  end

  test "support primitive data types with prepared statement", context do
    integer          = 1
    negative_integer = -1
    float            = 3.1415
    negative_float   = -3.1415
    string           = "Californication"
    text             = "Some random text"
    binary           = <<0,1>>
    table            = "basic_types_text_protocol"

    sql = ~s{CREATE TABLE #{table} } <>
          ~s{(id serial, active boolean, count integer, intensity float, } <>
          ~s{title varchar(20), body text(20), data blob)}

    :ok = query(sql, [])

    # Boolean
    #:ok = query("INSERT INTO #{table} (active) values (?)", [true])
    #assert [{true}] = query("SELECT active from #{table} WHERE id = LAST_INSERT_ID()", [])

    # Integer
    :ok = query("INSERT INTO #{table} (count) values (?)", [integer])
    assert query("SELECT count from #{table} WHERE id = LAST_INSERT_ID()", []) == [{integer}]
    :ok = query("INSERT INTO #{table} (count) values (?)", [negative_integer])
    #assert query("SELECT count from #{table} WHERE id = LAST_INSERT_ID()", []) == [{negative_integer}]

    # Float
    #:ok = query("INSERT INTO #{table} (intensity) values (?)", [float])
    #[{query_float}] = query("SELECT intensity from #{table} WHERE id = LAST_INSERT_ID()", [])
    #assert_in_delta query_float, float, 0.0001
    #:ok = query("INSERT INTO #{table} (intensity) values (?)", [negative_float])
    #[{query_negative_float}] = query("SELECT intensity from #{table} WHERE id = LAST_INSERT_ID()", [])
    #assert_in_delta query_negative_float, negative_float, 0.0001


    # String
    #:ok = query("INSERT INTO #{table} (title) values (?)", [string])
    #assert query("SELECT title from #{table} WHERE id = LAST_INSERT_ID()", []) == [{string}]
    #assert query("SELECT 'mø'", []) == [{"mø"}]

    # Text
    #:ok = query("INSERT INTO #{table} (body) values (?)", [text])
    #assert query("SELECT body from #{table} WHERE id = LAST_INSERT_ID()", []) == [{text}]

    # Binary
    #:ok = query("INSERT INTO #{table} (data) values (?)", [binary])
    #assert query("SELECT data from #{table} WHERE id = LAST_INSERT_ID()", []) == [{binary}]

    # Nil
    #assert query("SELECT null", []) == [{nil}]
  end


end
