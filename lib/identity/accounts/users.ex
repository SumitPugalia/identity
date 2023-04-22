defmodule Supu.Identity.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :active, :boolean, default: true
    field :email, :string
    field :mobile_number, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @cast_keys [:password, :password_confirmation, :password_hash,  :active, :email, :mobile_number]
  @required_keys [:password, :password_confirmation, :type, :active]

  @doc false
  def create_changeset(account, attrs) do
    account
    |> cast(attrs, @cast_keys)
    |> validate_required(@required_keys)
    |> validate_confirmation(:password, message: "Passwords does not match")
    |> put_password_hash()
  end

  @doc false
  def password_changeset(account, attrs) do
    account
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_confirmation(:password, message: "Passwords does not match")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    put_change(changeset, :password_hash, hashed_password(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

  defp hashed_password(nil) do
    nil
  end

  defp hashed_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
