defmodule EctoFields.Atom do
  @behaviour Ecto.Type
  def type, do: :string

  @doc """
  Coerce a regular string into an atom

  ## Examples

      iex> EctoFields.Atom.cast("started")
      {:ok, :started}

      iex> EctoFields.Atom.cast(:started)
      {:ok, :started}

      iex> EctoFields.Atom.cast(nil)
      {:ok, nil}
 """
  def cast(nil), do: {:ok, nil}
  def cast(str) when is_binary(str), do: {:ok, String.to_atom(str)}
  def cast(atom) when is_atom(atom), do: {:ok, atom}
  def cast(_), do: :error

  # when loading from the database convert to an atom
  def load(nil), do: {:ok, nil}
  def load(str), do: {:ok, String.to_atom(str)}

  # when dumping to the database it will automatically be converted to a string
  def dump(atom), do: {:ok, atom}
end
