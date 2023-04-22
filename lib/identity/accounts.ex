defmodule Identity.Accounts do

  def all() do
    repo.all(Identity.Accounts)
  end

  defp repo() do
    Application.get_env(:identity, :use_repo)
  end
end
