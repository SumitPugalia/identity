defmodule Identity.Migrations do
  @moduledoc false

  defdelegate up(opts \\ []), to: Identity.Migration
  defdelegate down(opts \\ []), to: Identity.Migration
end

defmodule Identity.Migration do
  @moduledoc """
  Migrations create and modify the database tables Identity needs to function.

  ## Usage

  To use migrations in your application you'll need to generate an `Ecto.Migration` that wraps
  calls to `Identity.Migration`:

  ```bash
  mix ecto.gen.migration add_Identity
  ```

  Open the generated migration in your editor and call the `up` and `down` functions on
  `Identity.Migration`:

  ```elixir
  defmodule MyApp.Repo.Migrations.AddIdentity do
    use Ecto.Migration

    def up, do: Identity.Migration.up()

    def down, do: Identity.Migration.down()
  end
  ```

  This will run all of Identity's versioned migrations for your database.

  Now, run the migration to create the table:

  ```bash
  mix ecto.migrate
  ```

  Migrations between versions are idempotent. As new versions are released, you may need to run
  additional migrations. To do this, generate a new migration:

  ```bash
  mix ecto.gen.migration upgrade_Identity_to_v11
  ```

  Open the generated migration in your editor and call the `up` and `down` functions on
  `Identity.Migration`, passing a version number:

  ```elixir
  defmodule MyApp.Repo.Migrations.UpgradeIdentityToV11 do
    use Ecto.Migration

    def up, do: Identity.Migration.up(version: 11)

    def down, do: Identity.Migration.down(version: 11)
  end
  ```

  ## Isolation with Prefixes

  Identity supports namespacing through PostgreSQL schemas, also called "prefixes" in Ecto. With
  prefixes your jobs table can reside outside of your primary schema (usually public) and you can
  have multiple separate job tables.

  To use a prefix you first have to specify it within your migration:

  ```elixir
  defmodule MyApp.Repo.Migrations.AddPrefixedIdentityJobsTable do
    use Ecto.Migration

    def up, do: Identity.Migrations.up(prefix: "private")

    def down, do: Identity.Migrations.down(prefix: "private")
  end
  ```

  The migration will create the "private" schema and all tables, functions and triggers within
  that schema. With the database migrated you'll then specify the prefix in your configuration:

  ```elixir
  config :my_app, Identity,
    prefix: "private",
    ...
  ```

  In some cases, for example if your "private" schema already exists and your database user in
  production doesn't have permissions to create a new schema, trying to create the schema from the
  migration will result in an error. In such situations, it may be useful to inhibit the creation
  of the "private" schema:

  ```elixir
  defmodule MyApp.Repo.Migrations.AddPrefixedIdentityJobsTable do
    use Ecto.Migration

    def up, do: Identity.Migrations.up(prefix: "private", create_schema: false)

    def down, do: Identity.Migrations.down(prefix: "private")
  end
  ```

  ## Migrating Without Ecto

  If your application uses something other than Ecto for migrations, be it an external system or
  another ORM, it may be helpful to create plain SQL migrations for Identity database schema changes.

  The simplest mechanism for obtaining the SQL changes is to create the migration locally and run
  `mix ecto.migrate --log-migrations-sql`. That will log all of the generated SQL, which you can
  then paste into your migration system of choice.

  Alternatively, if you'd like a more automated approach, try using the [Identity_migations_sql][sql]
  project to generate `up` and `down` SQL migrations for you.

  [sql]: https://github.com/btwb/Identity_migrations_sql
  """

  use Ecto.Migration

  @doc """
  Migrates storage up to the latest version.
  """
  @callback up(Keyword.t()) :: :ok

  @doc """
  Migrates storage down to the previous version.
  """
  @callback down(Keyword.t()) :: :ok

  @doc """
  Identifies the last migrated version.
  """
  @callback migrated_version(Keyword.t()) :: non_neg_integer()

  @doc """
  Run the `up` changes for all migrations between the initial version and the current version.

  ## Example

  Run all migrations up to the current version:

      Identity.Migration.up()

  Run migrations up to a specified version:

      Identity.Migration.up(version: 2)

  Run migrations in an alternate prefix:

      Identity.Migration.up(prefix: "payments")

  Run migrations in an alternate prefix but don't try to create the schema:

      Identity.Migration.up(prefix: "payments", create_schema: false)
  """
  def up(opts \\ []) when is_list(opts) do
    migrator().up(opts)
  end

  @doc """
  Run the `down` changes for all migrations between the current version and the initial version.

  ## Example

  Run all migrations from current version down to the first:

      Identity.Migration.down()

  Run migrations down to and including a specified version:

      Identity.Migration.down(version: 5)

  Run migrations in an alternate prefix:

      Identity.Migration.down(prefix: "payments")
  """
  def down(opts \\ []) when is_list(opts) do
    migrator().down(opts)
  end

  @doc """
  Check the latest version the database is migrated to.

  ## Example

      Identity.Migration.migrated_version()
  """
  def migrated_version(opts \\ []) when is_list(opts) do
    migrator().migrated_version(opts)
  end

  defp migrator do
    # case repo().__adapter__() do
    #   Ecto.Adapters.Postgres -> Identity.Migrations.Postgres
    #   Ecto.Adapters.SQLite3 -> Identity.Migrations.SQLite
    # end
    Identity.Migrations.Postgres
  end
end
