defmodule NotebookApiWeb.ContactView do
  use NotebookApiWeb, :view
  alias NotebookApiWeb.ContactView

  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    %{id: contact.id,
      name: contact.name,
      email: contact.email,
      birthdate: contact.birthdate}
  end
end
