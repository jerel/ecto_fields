defmodule EctoFields.IPV4 do
  @behaviour Ecto.Type
  def type, do: :string

  @doc """
  Validate that the given value is a valid ipv4

  ## Examples

      iex> EctoFields.IPV4.cast("192.168.10.1")
      {:ok, "192.168.10.1"}

      iex> EctoFields.IPV4.cast("2001:1620:28:1:b6f:8bca:93:a116")
      :error

      iex> EctoFields.IPV4.cast("http://example.com")
      :error
  """
  def cast(ip) when is_binary(ip) and byte_size(ip) > 0 do
    case ip |> String.to_char_list |> :inet_parse.ipv4strict_address do
      {:ok, _} -> {:ok, ip}
      {:error, _} -> :error
    end
  end

  def cast(nil), do: {:ok, nil}

  def cast(_), do: :error

  # converts a string to our ecto type
  def load(ip), do: {:ok, ip}

  # converts our ecto type to a string
  def dump(ip), do: {:ok, ip}
end
