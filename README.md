# Plasm

[![Build Status](https://travis-ci.org/atomic-fads/plasm.svg?branch=master)](https://travis-ci.org/atomic-fads/plasm)
[![Inline docs](http://inch-ci.org/github/atomic-fads/plasm.svg)](http://inch-ci.org/github/atomic-fads/plasm)

A generic [composable query](http://blog.drewolson.org/composable-queries-ecto/) library for [Ecto](https://github.com/elixir-lang/ecto).

:heart::heart::heart: Ecto, :cry::cry::cry: because I have to implement my own composable query functions for things like counting records, getting a random record and whatnot in all my models/projects.

NO MORE.

Plasm provides a set of generic, composable, higher-level functions that make working with Ecto more joyful and productive.


## Design Objectives

- [X] Work alongside `Ecto.Query` so both can be `import`ed without conflict
- [X] Avoid reimplementing basic `Ecto.Query` functionality where possible
- [X] Provide syntactic sugar for common queries (e.g., see `count` and `distinct_by`)
- [X] Easy integration with Phoenix
- [X] Permissive API (e.g., most functions that accept an atom will alternatively accept a string)
- [ ] Support all databases supported by Ecto (right now, use PostgreSQL for all functionality)


## Examples

Instead of writing this in your model:

``` elixir
defmodule MyGhostBustingApp.ProtonPack
  ...

  def count(query) do
    for q in query,
    select: count(q.id)
  end

  ...
end
```

And using it this way:

``` elixir
ProtonPack |> ProtonPack.count |> Repo.one
```

Just use Plasm:

``` elixir
ProtonPack |> Plasm.count |> Repo.one
```

More examples:

``` elixir
PkeMeter |> Plasm.updated_after("2016-01-04T14:00:00Z") |> Repo.all
```

``` elixir
GhostTrap |> Plasm.find([3,6,9]) |> Repo.all
```

``` elixir
StayPuftMarshmallowMan |> Plasm.random |> Repo.one
```

## Using in Models

You can import Plasm and use it directly in your models:

``` elixir
defmodule MyApp.SomeModel do
  import Ecto.Query
  import Plasm

  ...

  def random_distinct_names_by_order_of_insertion(query, n) do
    query
    |> order_by(asc: :inserted_at)
    |> distinct_by(:name)
    |> random(n)
  end
end
```


## Using with Phoenix

If you want Plasm to be universally accessible in all your Phoenix models, you can add it to `web.ex`:

``` elixir
defmodule MyApp.Web do
  ...

  def model do
    quote do
      ...

      import Plasm
    end
  end
end
```


## API

``` elixir
Plasm.avg(query, field_name)
Plasm.count(query)
Plasm.count_distinct(query, field_name)
Plasm.distinct_by(query, field_name)
Plasm.find(query, primary_key)
Plasm.find(query, primary_keys)
Plasm.first(query)
Plasm.first(query, n)
Plasm.inserted_after(query, ecto_date_time)
Plasm.inserted_after(query, string_castable_to_ecto_date_time)
Plasm.inserted_after_incl(query, ecto_date_time)
Plasm.inserted_after_incl(query, string_castable_to_ecto_date_time)
Plasm.inserted_before(query, ecto_date_time)
Plasm.inserted_before(query, string_castable_to_ecto_date_time)
Plasm.inserted_before_incl(query, ecto_date_time)
Plasm.inserted_before_incl(query, string_castable_to_ecto_date_time)
Plasm.max(query, field_name)
Plasm.min(query, field_name)
Plasm.last(query)
Plasm.last(query, n)
Plasm.random(query)
Plasm.random(query, n)
Plasm.sum(query, field_name)
Plasm.updated_after(query, ecto_date_time)
Plasm.updated_after(query, string_castable_to_ecto_date_time)
Plasm.updated_after_incl(query, ecto_date_time)
Plasm.updated_after_incl(query, string_castable_to_ecto_date_time)
Plasm.updated_before(query, ecto_date_time)
Plasm.updated_before(query, string_castable_to_ecto_date_time)
Plasm.updated_before_incl(query, ecto_date_time)
Plasm.updated_before_incl(query, string_castable_to_ecto_date_time)
Plasm.where_all(query, field_names_and_values)
Plasm.where_none(query, field_names_and_values)
```


## Note On DB Support

Plasm aims to support all DBs supported by Ecto, but we're not quite there yet. Right now, the only functions that don't work cross-DB are `random\1` and `random\2`, which are supported only on PostgreSQL for now.


## Note On Query Syntaxes

Ecto supports two query syntaxes, **keyword** and **query expression**.

Example of the **keyword** syntax:

``` elixir
def for_name_or_age(query, name, age) do
  for x in query,
  where: x.name == ^name or x.age == ^age
end
```

Example of the **query expression** syntax:

``` elixir
def for_name_or_age(query, name, age) do
  query
  |> where([x], x.name == ^name or x.age == ^age)
end
```

The keyword syntax is a bit easier on the eyes, but is not fully compatible with Plasm. A case can be made for sticking with the query expression syntax for all functions that are meant to be composable, and especially if you plan to use Plasm or something like it.


## Inspiration

Many thanks to [Drew Olson](https://github.com/drewolson) for his [talk at ElixirConf 2015](https://www.youtube.com/watch?v=g84TDHt9MDc) and [insightful blog post](http://blog.drewolson.org/composable-queries-ecto/) on the subject of composable Ecto queries.

Also thanks to [Henrik Nyh](https://github.com/henrik) for his [Ectoo](https://github.com/henrik/ectoo) project, which has similar aims.


## TODO:

- [x] Tests
- [x] Hex docs


## Installation

Add Plasm to your list of dependencies in `mix.exs`:

``` elixir
def deps do
  [{:plasm, "~> 0.1.0"}]
end
```

Ensure Plasm is started before your application:

``` elixir
def application do
  [
    applications: [
      ...
      :plasm
      ...
    ]
  ]
end
```

If you want to be on the bleeding edge, track the `master` branch of this repo:

``` elixir
{:plasm, git: "https://github.com/atomic-fads/plasm.git", branch: "master"}
```


## Copyright and License

Copyright (c) 2016, Atomic Fads LLC.

Plasm source code is licensed under the Apache 2 License (see LICENSE.md).
