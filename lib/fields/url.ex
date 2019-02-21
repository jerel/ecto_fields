defmodule EctoFields.URL do
  @behaviour Ecto.Type
  def type, do: :string

  @doc """
  Validate that the given value is a valid fully qualified url

  ## Examples

      iex> EctoFields.URL.cast("http://example.com")
      {:ok, "http://example.com"}

      iex> EctoFields.URL.cast("https://example.com")
      {:ok, "https://example.com"}

      iex> EctoFields.URL.cast("http://example.com/test/foo.html?search=1&page=two#header")
      {:ok, "http://example.com/test/foo.html?search=1&page=two#header"}

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

    case String.to_charlist(domain) |> :inet_parse.domain() do
      true -> {url, Enum.join(uri, "/")}
      _ -> :error
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
