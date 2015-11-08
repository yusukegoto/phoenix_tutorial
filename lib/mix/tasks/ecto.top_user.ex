defmodule Mix.Tasks.Ecto.TopUser do
  use Mix.SampleApp

  @shortdoc "Show first User"
  def run(args) do
    open_repo(args) do
      user = case Repo.all(from u in User, limit: 1) do
               [user | _] -> user
               _          -> nil
             end
      Mix.shell.info inspect(user)
    end
  end
end
