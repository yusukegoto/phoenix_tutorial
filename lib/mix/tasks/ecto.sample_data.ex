defmodule Mix.Tasks.Ecto.SampleData do
  use Mix.SampleApp

  @shortdoc "Fill database with sample data"

  def run(args) do
    Faker.start
    repo = parse_repo args
    {:ok, pid} = ensure_started repo

    last_count = users_count

    for _ <- 0..10 do
      {name, email} = faker
      password = "password"
      changeset = User.changeset %User{}, %{
        name: name,
        email: email,
        password: password,
        password_confirmation: password }

      {:ok, user} = Repo.insert changeset
      IO.inspect("#{user.id}: #{user.name}")
    end

    Mix.shell.info "count: #{users_count - last_count}"

    pid && ensure_stopped(pid)
  end

  defp users_count do
    query = from(u in User,
      select: {count(u.id)})
    [{count}] = Repo.all(query)
    count
  end

  defp add_email_domain(prefix) do
    prefix <> "@mail.com"
  end

  defp fakeemail(name) do
    name
    |> String.replace(~r/[. ']/, "")
    |> String.downcase
    |> add_email_domain
  end

  # returns unique name
  defp faker do
    name  = Faker.Name.name
    email = fakeemail(name)
    if Repo.get_by User, name: name, email: email do
      faker
    else
      {name, fakeemail(name)}
    end
  end
end
