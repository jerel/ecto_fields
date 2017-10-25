defmodule EctoFieldsTest do
  use ExUnit.Case
  doctest EctoFields

  doctest EctoFields.Email
  doctest EctoFields.IP
  doctest EctoFields.IPv4
  doctest EctoFields.IPv6
  doctest EctoFields.PositiveInteger
  doctest EctoFields.Slug
  doctest EctoFields.URL
  doctest EctoFields.Atom
  doctest EctoFields.Static
end
