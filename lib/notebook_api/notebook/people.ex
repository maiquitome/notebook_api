defmodule NotebookApi.Notebook.People do
  alias NotebookApi.Notebook.Contact

  def add_people(n) when n <= 0 do
    IO.puts "Successfully registered contacts!"
  end

  def add_people(n) do
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
      |> Contact.changeset(
        %{
          birthdate: Faker.Date.date_of_birth(18..65),
          email: "#{name_email}@#{Faker.Internet.PtBr.free_email_service}",
          name: name
        }
      )
    )
    add_people(n - 1)
  end
end
