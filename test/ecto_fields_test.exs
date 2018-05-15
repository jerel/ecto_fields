defmodule EctoFieldsTest do
  use ExUnit.Case
  use PropCheck

  doctest(EctoFields)

  doctest(EctoFields.Email)
  doctest(EctoFields.IP)
  doctest(EctoFields.IPv4)
  doctest(EctoFields.IPv6)
  doctest(EctoFields.PositiveInteger)
  doctest(EctoFields.Slug)
  doctest(EctoFields.URL)
  doctest(EctoFields.Atom)
  doctest(EctoFields.Static)

  property("EctoFields.Atom") do
    forall(atom in oneof([atom(), atom_utf8()])) do
      string = Atom.to_string(atom)

      {:ok, atom} == EctoFields.Atom.cast(string) and {:ok, atom} == EctoFields.Atom.load(string) and
        {:ok, string} == EctoFields.Atom.dump(atom)
    end
  end

  @doc false
  defp atom_utf8() do
    :proper_types.new_type(
      [
        {:generator, &atom_utf8_gen/1},
        {:reverse_gen, &atom_utf8_rev/1},
        {:size_transform, fn size -> :erlang.min(size, 255) end},
        {:is_instance, &atom_utf8_is_instance/1}
      ],
      :wrapper
    )
  end

  @doc false
  defp atom_utf8_gen(size) when is_integer(size) and size >= 0 do
    let(string <- such_that(x <- :proper_unicode.utf8(size), when: x === <<>> or :binary.first(x) !== ?$)) do
      :erlang.binary_to_atom(string, :utf8)
    end
  end

  @doc false
  defp atom_utf8_rev(atom) when is_atom(atom) do
    {:"$used", :erlang.atom_to_list(atom), atom}
  end

  @doc false
  defp atom_utf8_is_instance(x) do
    is_atom(x) and (x === :"" or :erlang.hd(:erlang.atom_to_list(x)) !== ?$)
  end
end
