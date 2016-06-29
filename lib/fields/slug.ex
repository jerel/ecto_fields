defmodule EctoFields.Slug do
  @behaviour Ecto.Type
  def type, do: :string

  @doc """
  Coerce a regular string into a slug

  ## Examples

      iex> EctoFields.Slug.cast("   My latest blog post-")
      {:ok, "my-latest-blog-post"}

      iex> EctoFields.Slug.cast("From the ЉЊАБЖЗ Naughty ЁЂЃЄ Strings цчшщъыьэюя list")
      {:ok, "from-the-naughty-strings-list"}
  """
  def cast(title) when is_binary(title) and byte_size(title) > 0 do
    slug = title
    |> String.normalize(:nfd)
    |> String.downcase
    |> String.replace(~r/[^a-z\s]/u, "")
    |> String.replace(~r/\s+/, "-")
    |> String.replace(~r/^\-*(.*?)\-*$/, "\\1")

    {:ok, slug}
  end

  def cast(nil), do: {:ok, nil}

  def cast(_), do: :error

  # converts a string to our ecto type
  def load(slug), do: {:ok, slug}

  # converts our ecto type to a string
  def dump(slug), do: {:ok, slug}
end
