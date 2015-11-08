defmodule Mix.SampleApp do
  defmacro __using__(_) do
    quote do
      use Mix.Task
      alias SampleApp.User
      alias SampleApp.Repo
      import Ecto.Query
      import Mix.Ecto
    end
  end
end
