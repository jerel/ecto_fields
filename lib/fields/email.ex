defmodule EctoFields.Email do
  @behaviour Ecto.Type
  def type, do: :string

  @doc """
  Validate that the given value is a valid email

  ## Examples

      iex> EctoFields.Email.cast("foo.bar@example.com")
      {:ok, "foo.bar@example.com"}

      iex> EctoFields.Email.cast("foo.bar+baz/@long.example.photography.uk")
      {:ok, "foo.bar+baz/@long.example.photography.uk"}

      iex> EctoFields.Email.cast("test@localhost")
      {:ok, "test@localhost"}

      iex> EctoFields.Email.cast("test@192.168.10.1")
      {:ok, "test@192.168.10.1"}

      iex> EctoFields.Email.cast("test@2001:1620:28:1:b6f:8bca:93:a116")
      {:ok, "test@2001:1620:28:1:b6f:8bca:93:a116"}

      iex> EctoFields.Email.cast("foo.bar@example.com/")
      :error

      iex> EctoFields.Email.cast("foo.bar@example.com.")
      :error

      iex> EctoFields.Email.cast("bad email")
      :error

      iex> EctoFields.Email.cast("test@example.com<script src='x.js'>")
      :error
  """
  # max_length=254 to be compliant with RFCs 3696 and 5321
  def cast(email) when is_binary(email) and byte_size(email) > 0 and byte_size(email) < 255 do
    # Thanks to the Django Project for the regex inspiration.
    # https://tools.ietf.org/html/rfc2822#section-3.2.4
    user_regex = Regex.compile!("(^[-!#$%&'*+/=?^_`{}|~0-9A-Z]+(\.[-!#$%&'*+/=?^_`{}|~0-9A-Z]+)*\\z)", [:caseless, :multiline])

    # limited to label length of 63 per RFC 1034
    domain_regex = Regex.compile!("((?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+)(?:[A-Z0-9-]{2,63}(?<!-))\\z", [:caseless, :multiline])

    result = with [user, domain] <- String.split(email, "@"),
         true <- Regex.match?(user_regex, user),
         true <- Regex.match?(domain_regex, domain) || domain == "localhost" || is_valid_ip?(domain) do
      true
    end

    # workaround missing with/else for Elixir 1.2
    case result do
      true -> {:ok, email}
      _    -> :error
    end
  end

  def cast(nil), do: {:ok, nil}

  def cast(_) do
    :error
  end

  # converts a string to our ecto type
  def load(email), do: {:ok, email}

  # converts our ecto type to a string
  def dump(email), do: {:ok, email}


  defp is_valid_ip?(domain) do
    case domain |> String.to_char_list |> :inet_parse.address do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

end
