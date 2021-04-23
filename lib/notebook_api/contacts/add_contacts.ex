defmodule NotebookApi.Contacts.AddContacts do
  alias NotebookApi.Contacts.Contact

  def add_contacts(n) when n <= 0 do
  end

  def add_contacts(n) do
    name = Faker.Person.PtBr.name()

    name_email =
      name
      |> String.replace(" ", "")
      |> String.downcase()
      # "árboles más grandes -> arboles mas grandes"
      |> String.normalize(:nfd)
      |> String.replace(~r/[^A-Za-z\s]/u, "")

    NotebookApi.Repo.insert!(
      %Contact{}
      |> Contact.changeset(%{
        birthdate: Faker.Date.date_of_birth(18..65),
        email: "#{name_email}@#{Faker.Internet.PtBr.free_email_service()}",
        name: name,
        kind_id: return_a_kind().id
      })
    )

    add_contacts(n - 1)
  end

  defp return_a_kind() do
    NotebookApi.Repo.all(NotebookApi.Kinds.Kind)
    |> Enum.random()
  end
end
