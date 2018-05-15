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

  @max_atom_length 0xFF

  @impl Ecto.Type
  def type(), do: :string

  @impl Ecto.Type
  def cast(nil), do: {:ok, nil}
  def cast(atom) when is_atom(atom), do: {:ok, atom}
  def cast(binary) when is_binary(binary) and byte_size(binary) <= @max_atom_length, do: {:ok, String.to_atom(binary)}
  def cast(_), do: :error

  # when loading from the database convert to an atom
  @impl Ecto.Type
  def load(term), do: cast(term)

  # save to the database
  @impl Ecto.Type
  def dump(nil), do: {:ok, nil}
  def dump(atom) when is_atom(atom), do: {:ok, Atom.to_string(atom)}
  def dump(binary) when is_binary(binary) and byte_size(binary) <= @max_atom_length, do: {:ok, binary}
  def dump(_), do: :error
end
