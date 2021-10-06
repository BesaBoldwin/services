defmodule Services.Notifications.Services.Email do
  @moduledoc """
  The Admin.Email context.
  """

  import Ecto.Query, warn: false
  alias Services.Repo

  alias Services.Notification.Schema.Emails

  @doc """
  Returns the list of Emailss.

  ## Examples

      iex> list_Emailss()
      [%Emails{}, ...]

  """
  def list_emailss do
    Repo.all(Emails)
  end

  @doc """
  Gets a single Emails.

  Raises `Ecto.NoResultsError` if the Emails does not exist.

  ## Examples

      iex> get_Emails!(123)
      %Emails{}

      iex> get_Emails!(456)
      ** (Ecto.NoResultsError)

  """
  def get_emails!(id), do: Repo.get!(Emails, id)

  @doc """
  Creates a Emails.

  ## Examples

      iex> create_Emails(%{field: value})
      {:ok, %Emails{}}

      iex> create_Emails(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_emails(attrs \\ %{}) do
    %Emails{}
    |> Emails.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Emails.

  ## Examples

      iex> update_Emails(Emails, %{field: new_value})
      {:ok, %Emails{}}

      iex> update_Emails(Emails, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_emails(%Emails{} = emails, attrs) do
    emails
    |> Emails.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Emails.

  ## Examples

      iex> delete_Emails(Emails)
      {:ok, %Emails{}}

      iex> delete_Emails(Emails)
      {:error, %Ecto.Changeset{}}

  """
  def delete_emails(%Emails{} = emails) do
    Repo.delete(emails)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Emails changes.

  ## Examples

      iex> change_Emails(Emails)
      %Ecto.Changeset{data: %Emails{}}

  """
  def change_emails(%Emails{} = email, attrs \\ %{}) do
    Email.changeset(email, attrs)
  end
end
