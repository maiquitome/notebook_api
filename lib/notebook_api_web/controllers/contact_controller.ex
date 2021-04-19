defmodule NotebookApiWeb.ContactController do
  use NotebookApiWeb, :controller

  alias NotebookApi.Notebook
  alias NotebookApi.Notebook.Contact

  action_fallback NotebookApiWeb.FallbackController

  def index(conn, _params) do
    contacts = Notebook.list_contacts()
    render(conn, "index.json", contacts: contacts)
  end

  def create(conn, %{"contact" => contact_params}) do
    with {:ok, %Contact{} = contact} <- Notebook.create_contact(contact_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.contact_path(conn, :show, contact))
      |> render("show.json", contact: contact)
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Notebook.get_contact!(id)
    render(conn, "show.json", contact: contact)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Notebook.get_contact!(id)

    with {:ok, %Contact{} = contact} <- Notebook.update_contact(contact, contact_params) do
      render(conn, "show.json", contact: contact)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Notebook.get_contact!(id)

    with {:ok, %Contact{}} <- Notebook.delete_contact(contact) do
      send_resp(conn, :no_content, "")
    end
  end
end
