defmodule EctoFields.PositiveInteger do
  @behaviour Ecto.Type
  def type, do: :integer

  @doc """
    Validate that the given value is a positive integer.

    ## Examples

    iex> EctoFields.PositiveInteger.cast(1)
    1

    iex> EctoFields.PositiveInteger.cast(0)
    :error

    iex> EctoFields.PositiveInteger.cast(-10)
    :error
  """
  def cast(int) when is_integer(int) and int > 0 do
    int
  end

  def cast(_), do: :error

  # converts a value to our ecto type
  def load(int), do: {:ok, int}

  # converts our ecto type to a value
  def dump(int), do: {:ok, int}
end
