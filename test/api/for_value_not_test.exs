defmodule Plasm.Api.ForValueNotTest do
  use Plasm.ApiCase

  test ".for_value_not with a binary field name" do
    field_name = "name"
    atom_field_name = String.to_atom(field_name)
    field_value = "Mulder"

    plasm_query_string =
      Plasm.User
      |> Plasm.for_value_not(field_name, field_value)
      |> query_to_string

    ecto_query_string =
      Ecto.Query.from(
        u in Plasm.User,
        where: field(u, ^atom_field_name) != ^field_value
      )
      |> query_to_string

    assert plasm_query_string == ecto_query_string
  end

  test ".for_value_not with an atom field name" do
    field_name = :name
    field_value = "Mulder"

    plasm_query_string =
      Plasm.User
      |> Plasm.for_value_not(field_name, field_value)
      |> query_to_string

    ecto_query_string =
      Ecto.Query.from(
        u in Plasm.User,
        where: field(u, ^field_name) != ^field_value
      )
      |> query_to_string

    assert plasm_query_string == ecto_query_string
  end
end
