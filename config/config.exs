import Config

config :identity, Identity.Test.Repo,
  database: "identity_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :identity,
  ecto_repos: [Identity.Test.Repo]
