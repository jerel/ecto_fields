defmodule EctoFieldsTest do
  use ExUnit.Case
  doctest EctoFields

  doctest EctoFields.Email
  doctest EctoFields.IP
  doctest EctoFields.IPV4
  doctest EctoFields.IPV6
  doctest EctoFields.PositiveInteger
  doctest EctoFields.Slug
  doctest EctoFields.URL
end
