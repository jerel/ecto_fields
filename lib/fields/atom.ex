defmodule EctoFields.Atom do
  @moduledoc """
  Coerce a regular string into an atom

  ## Examples

  Note: only use this field when you have a fixed number of possible values (atoms are not garbage collected)

      iex> EctoFields.Atom.cast("started")
      {:ok, :started}

      iex> EctoFields.Atom.cast(:started)
      {:ok, :started}

      iex> EctoFields.Atom.cast(nil)
      {:ok, nil}
 """
  @behaviour Ecto.Type
  def type, do: :string

  def cast(nil), do: {:ok, nil}
  def cast(str) when is_binary(str), do: {:ok, String.to_atom(str)}
  def cast(atom) when is_atom(atom), do: {:ok, atom}
  def cast(_), do: :error

  # when loading from the database convert to an atom
  def load(nil), do: {:ok, nil}
  def load(str), do: {:ok, String.to_atom(str)}

  # save to the database
  def dump(nil), do: {:ok, nil}
  def dump(atom), do: {:ok, to_string(atom)}
end
