defmodule EctoFields.URL do
  @behaviour Ecto.Type

  def type, do: :string

  @doc """
  Validate that the given value is a valid fully qualified url

  ## Examples

      iex> EctoFields.URL.cast("http://1.1.1.1")
      {:ok, "http://1.1.1.1"}

      iex> EctoFields.URL.cast("http://example.com")
      {:ok, "http://example.com"}

      iex> EctoFields.URL.cast("https://example.com")
      {:ok, "https://example.com"}

      iex> EctoFields.URL.cast("http://example.com/test/foo.html?search=1&page=two#header")
      {:ok, "http://example.com/test/foo.html?search=1&page=two#header"}

      iex> EctoFields.URL.cast("http://example.com:8080/")
      {:ok, "http://example.com:8080/"}

      iex> EctoFields.URL.cast("myblog.html")
      :error

      iex> EctoFields.URL.cast("http://example.com\blog\first")
      :error
  """
  def cast(url) when is_binary(url) and byte_size(url) > 0 do
    url
    |> validate_protocol
    |> validate_host
    |> validate_uri
  end

  def cast(nil), do: {:ok, nil}

  def cast(_), do: :error

  # converts a string to our ecto type
  def load(url), do: {:ok, url}

  # converts our ecto type to a string
  def dump(url), do: {:ok, url}

  def embed_as(_), do: :self

  def equal?(a, b), do: a == b

  defp validate_protocol("http://" <> rest = url) do
    {url, rest}
  end

  defp validate_protocol("https://" <> rest = url) do
    {url, rest}
  end

  defp validate_protocol(_), do: :error

  defp validate_host(:error), do: :error

  defp validate_host({url, rest}) do
    [domain | uri] = String.split(rest, "/")

    domain =
      case String.split(domain, ":") do
        # ipv6
        [_, _, _, _, _, _, _, _] -> domain
        [domain, _port] -> domain
        _ -> domain
      end

    erl_host = String.to_charlist(domain)

    if :inet_parse.domain(erl_host) or
         match?({:ok, _}, :inet_parse.ipv4strict_address(erl_host)) or
         match?({:ok, _}, :inet_parse.ipv6strict_address(erl_host)) do
      {url, Enum.join(uri, "/")}
    else
      :error
    end
  end

  defp validate_uri(:error), do: :error

  defp validate_uri({url, uri}) do
    if uri == URI.encode(uri) |> URI.decode() do
      {:ok, url}
    else
      :error
    end
  end
end
